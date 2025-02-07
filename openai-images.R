library(tidyverse)
library(openai)
library(httr)
library(jsonlite)

z <- "A professional digital illustration featuring a confident woman, with a polished appearance. She has medium-length dark hair styled neatly, wearing a business-casual outfit, consisting of a tailored blazer and a soft-colored blouse. The background is a gradient of neutral tones, giving a modern, LinkedIn-style look, with a faint abstract design that suggests professionalism and a digital context."
new_key <- Sys.getenv("OPENAI_API_KEY")

z1 <- create_image(z)


response <- POST(
  url = "https://api.openai.com/v1/images/generations",
  add_headers(Authorization = paste("Bearer", new_key)),
  content_type_json(),
  encode = "json",
  body = list(
    model = "dall-e-3",
    temperature = 1,
    messages = list(list(
      role = "user",
      content = z
    )),
    stream = F
  )
)
