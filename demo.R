# =====================================================================================================================
# Perceptual Hashing
# =====================================================================================================================

# Requirements --------------------------------------------------------------------------------------------------------
install.packages('OpenImageR')
install.packages('plumber')
install.packages('httr')
devtools::install_github("rayheberer/imgnoise")

library(OpenImageR)
library(imgnoise)

library(plumber)

library(e1071) # for Hamming distance

# Reading and Displaying Images ---------------------------------------------------------------------------------------
bts1 <- OpenImageR::readImage('./img/bts1.jpg')

OpenImageR::imageShow(bts1)
imageShow('./img/bts2.jpg')

# Applying Transformations and Noise ----------------------------------------------------------------------------------
bts1.resized <- OpenImageR::resizeImage(bts1, 250, 250)
imageShow(bts1.resized)

bts1.rotated <- OpenImageR::rotateImage(bts1, 5)
bts1.rotated2 <- rotateImage(bts1, 10)

bts1.pinknoise <- imgnoise::imgnoise(bts1, 'uniform', -0.1, 0.1)

bts1.SnPnoise <- imgnoise(bts1, 'salt_and_pepper')

OpenImageR::writeImage(bts1.resized, './img/bts1_resized.jpg')
writeImage(bts1.rotated, './img/bts1_rotated.jpg')
writeImage(bts1.rotated2, './img/bts1_rotated2.jpg')
writeImage(bts1.pinknoise, './img/bts1_pinknoise.jpg')
writeImage(bts1.SnPnoise, './img/bts1_SnPnoise.jpg')

# Grayscaling ---------------------------------------------------------------------------------------------------------
bts1 <- OpenImageR::rgb_2gray(bts1)

bts2 <- readImage('./img/bts2.jpg')
bts3 <- readImage('./img/bts3.jpg')
bts4 <- readImage('./img/bts4.jpg')

bts2 <- rgb_2gray(bts2)
bts3 <- rgb_2gray(bts3)
bts4 <- rgb_2gray(bts4)

# Computing Hashes ----------------------------------------------------------------------------------------------------
bts1.phash <- OpenImageR::phash(bts1)

bts1.phash <- phash(bts1, MODE = 'binary')

bts2.phash <- phash(bts2, MODE = 'binary')
bts3.phash <- phash(bts3, MODE = 'binary')
bts4.phash <- phash(bts4, MODE = 'binary')

# Calculating Hamming Distance ----------------------------------------------------------------------------------------
bts1.resized <- rgb_2gray(bts1.resized)
bts1.resized.phash <- phash(bts1.resized, MODE='binary')

e1071::hamming.distance(bts1.resized.phash, bts1.phash) # should throw error

hamming.distance(as.vector(bts1.resized.phash), as.vector(bts1.phash))
hamming.distance(c(bts2.phash), c(bts1.phash))

# Creating Hash Table using R Environment -----------------------------------------------------------------------------
hash <- new.env()

keys <- c('bts1', 'bts2', 'bts3', 'bts4')

lapply(keys, function(k) {
  hash[[k]] <- c(eval(parse(text=paste0(k,'.phash'))))
})

lapply(hash, function(h) {
  hamming.distance(h, c(bts1.resized.phash))
})

saveRDS(hash, './data/hash_table.rds')

# Exposing an API that does the above steps ---------------------------------------------------------------------------
api <- plumber::plumb('api.R')
api$run(port = 8000)
