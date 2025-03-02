# https://codeberg.org/tim-salabim/snippets/src/branch/main/visusalize_s2_cells_globe.R

library(mapgl)
library(s2)
library(colourvalues)
library(yyjsonr)

dat = data.frame(
  token = as.character(
    s2_cell_parent(
      as_s2_cell(
        s2_lnglat(-75.7019612, 45.4186427)
      )
      , level = 1:30
    )
  )
  , value = seq(10, 1000, length.out = 30)
)
dat$fillColor = colour_values(dat$value, alpha = 30, palette = "inferno")

map = maplibre(style = 'https://basemaps.cartocdn.com/gl/positron-gl-style/style.json') |>
  add_navigation_control(visualize_pitch = TRUE) |>
  add_layers_control(collapsible = TRUE, layers = c("test"))

map$dependencies = c(
  map$dependencies
  , list(
    htmltools::htmlDependency(
      "deck.gl"
      , "9.1.4"
      , src = c(
        href = "https://cdn.jsdelivr.net/npm/deck.gl@9.1.4"
      )
      , script = "dist.min.js"
    )
  )
  , list(
    htmltools::htmlDependency(
      "deck.gl"
      , "9.1.4"
      , src = c(
        href = "https://cdn.jsdelivr.net/npm/@deck.gl/mapbox@9.1.4/dist/"
      )
      , script = "mapbox-overlay.min.js"
    )
  )
)


htmlwidgets::onRender(
  map
  , htmlwidgets::JS(
    "function(el, x, data) {
        debugger;

        map = this.getMap();
        let globecontrol = new maplibregl.GlobeControl();
        map.addControl(globecontrol);

        function hexToRGBA(hex) {
            // remove invalid characters
            hex = hex.replace(/[^0-9a-fA-F]/g, '');
            if (hex.length < 5) {
                hex = hex.split('').map(s => s + s).join('');
            }
            // parse pairs of two
            let rgba = hex.match(/.{1,2}/g).map(s => parseInt(s, 16));
            return rgba;
        }

        let s2Plot = new deck.S2Layer({
          id: 'test',
          data: JSON.parse(data.x),
          extruded: true,
          filled: true,
          lineWidthMaxPixels: 1,
          getS2Token: d => d.token,
          getFillColor: d => hexToRGBA(d.fillColor),
          getElevation: d => d.value,
          elevationScale: 1,
          wireframe: true,
        });

        var decklayer = new deck.MapboxOverlay({
          interleaved: true,
          layers: [s2Plot],
        });

        map.addControl(decklayer);
        map.setMaxZoom(300);
      }"
  )
  , data = list(
    x = yyjsonr::write_json_str(dat)
  )
)
