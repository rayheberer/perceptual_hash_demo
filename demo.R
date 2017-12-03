# =====================================================================================================================
# Perceptual Hashing
# =====================================================================================================================

# Requirements --------------------------------------------------------------------------------------------------------
install.packages('OpenImageR')
devtools::install_github("rayheberer/imgnoise")

library(OpenImageR)
library(imgnoise)

library(e1071) # for Hamming distance

# Reading and Displaying Images ---------------------------------------------------------------------------------------
bts1 <- OpenImageR::readImage('./img/bts1.jpg')

OpenImageR::imageShow(bts1)
imageShow('./img/bts2.jpg')

# Applying Transformations and Noise ----------------------------------------------------------------------------------
bts1.resized <- OpenImageR::resizeImage(bts1, 250, 250)
imageShow(bts1.resized)

bts1.rotated <- OpenImageR::rotateImage(bts1, 10)

bts1.pinknoise <- imgnoise::imgnoise(bts1, 'uniform', -0.1, 0.1)

bts1.SnPnoise <- imgnoise(bts1, 'salt_and_pepper')

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

bts1.phash <- phash(bts1, MODE='binary')

bts2.phash <- phash(bts2, MODE='binary')
bts3.phash <- phash(bts3, MODE='binary')
bts4.phash <- phash(bts4, MODE='binary')

# Creating Hash Table using R Environment -----------------------------------------------------------------------------


# Calculating Hamming Distance ----------------------------------------------------------------------------------------
bts1.resized <- rgb_2gray(bts1.resized)
bts1.resized.phash <- phash(bts1.resized, MODE='binary')

e1071::hamming.distance(bts1.resized.phash, bts1.phash) # should throw error

hamming.distance(as.vector(bts1.resized.phash), as.vector(bts1.phash))


# Exposing an API that does the above steps ---------------------------------------------------------------------------
