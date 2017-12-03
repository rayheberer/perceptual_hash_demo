#' @get /phash
function(image_path) {
  image <- OpenImageR::readImage(image_path)
  image <- OpenImageR::rgb_2gray(image)
  
  image.phash <- OpenImageR::phash(image, MODE = 'binary')
  image.phash <- c(image.phash)
  
  hash.table <- readRDS('./data/hash_table.rds')
  
  distances <- lapply(hash.table, function(h) {
    e1071::hamming.distance(h, image.phash)
  })
  
  distances
}