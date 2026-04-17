library(tidyverse)
library(tabulizer)

my_url <- "https://www.tudublin.ie/media/website/for-students/student-services-and-support/examinations/tallaght/PUBLISH-TT-NEW.pdf"

gg_url <- "https://www.tudublin.ie/media/website/for-students/student-services-and-support/examinations/documents/Grangegorman-Campus-Semester-Two-Exams-Timetable.pdf"

z <- extract_tables(my_url, pages = 1:10)

z1 <- map_df(1:10, function(i) z[[i]] |> as_tibble())
names(z1) <- z1[1,]
z1 <- z1 |>
  filter(Year != "Year") |>
  janitor::clean_names()

tu876 <- z1 |>
  filter(year == 4, tu_code == "TU876") |>
  select(-c(year, tu_code, school, course_title)) |>
  arrange(date)

tu936 <- z1 |>
  filter(year == 1, tu_code == "TU936") |>
  select(-c(year, tu_code, school, course_title)) |>
  arrange(date)


# Thu Apr 16 10:57:09 2026 ------------------------------

gg <- extract_tables(gg_url, pages = 1:40, method = "lattice")
z_gg <- map_df(1:40, function(i) gg[[i]] |> as_tibble())
names(z_gg) <- z_gg[1,]
z_gg <- z_gg |>
  filter(School != "School") |>
  janitor::clean_names()

tu880 <- z_gg |>
  filter(year == 2, tu_code == "TU880") |>
  select(module_name, module_co_ord, date, time, venue) |>
  mutate(new_date = date |>
           str_remove("(?<=[0-9])(st|nd|rd|th)") |>
           as.Date(format = "%A %d %B")) |>
  arrange(new_date) |>
  select(-new_date)

tu877 <- z_gg |>
  filter(year == 2, tu_code == "TU877") |>
  select(module_name, module_co_ord, date, time, venue) |>
  mutate(new_date = date |>
           str_remove("(?<=[0-9])(st|nd|rd|th)") |>
           as.Date(format = "%A %d %B")) |>
  arrange(new_date) |>
  select(-new_date)

tu878 <- z_gg |>
  filter(year == 2, tu_code == "TU878") |>
  select(module_name, module_co_ord, date, time, venue) |>
  mutate(new_date = date |>
           str_remove("(?<=[0-9])(st|nd|rd|th)") |>
           as.Date(format = "%A %d %B")) |>
  arrange(new_date) |>
  select(-new_date)

tu879 <- z_gg |>
  filter(year == 2, tu_code == "TU879") |>
  select(module_name, module_co_ord, date, time, venue) |>
  mutate(new_date = date |>
           str_remove("(?<=[0-9])(st|nd|rd|th)") |>
           as.Date(format = "%A %d %B")) |>
  arrange(new_date) |>
  select(-new_date)


