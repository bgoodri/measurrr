library(tidyverse)
library(glue)

logit <- function(x) {
  log(p / (1 - p))
}
inv_logit <- function(x) {
  1 / (1 + exp(-x))
}

n_items <- 30
n_people <- 1000

a_param <- rlnorm(n = n_items, meanlog = 0, sdlog = 0.7)
b_param <- rnorm(n = n_items, mean = 0, sd = 0.7)
c_param <- rbeta(n = n_items, shape1 = 5, shape2 = 17)
theta <- rnorm(n = n_people, mean = 0, sd = 1)

items <- bind_cols(a = a_param, b = b_param, c = c_param)

sim_irt <- map_dfr(theta, function(cur_theta, items) {
  pmap_int(items, function(a, b, c, z) {
    as.integer(rbernoulli(1, p = c + (1 - c) * inv_logit(a * (z - b))))
  }, z = cur_theta) %>%
    as_data_frame() %>%
    mutate(item = glue("item_{sprintf('%02d', seq_len(nrow(.)))}")) %>%
    spread(key = item, value = value)
}, items = items)

usethis::use_data(sim_irt)