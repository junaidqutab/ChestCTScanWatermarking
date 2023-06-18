# Watermarking of chest CT scan medical images for content authentication

## Implementation of [Paper](https://www.tandfonline.com/doi/abs/10.1080/00207161003596690), without the patient records part.
 
### Group members 

- 19L-1841 Muhammad Asad Bin Hameed
- 19L-2413 Syed Junaid Qutab

Embedding > Load > thresh > load logo > embed

Extraction  > Load in extraction axes (top right) > Extract

Water mark > 64 x 64 size

Testing > Jpg  / Median filter / Histeq destroys water mark > Lossless compression >Png keeps watermark intact

Images folder > Has logo / original image / watermarked images png / watermarked images jpg compressed / watermarked images with median filter

water marked images with hist eq
