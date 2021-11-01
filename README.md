# [waifu2x-converter-cpp by DeadSix27](https://github.com/DeadSix27/waifu2x-converter-cpp) built from source

## Usage
```console
$ docker run --rm -it -v <host_dir>:/work redpeacock78/waifu2x -p 0 -m noise-scale --scale-ratio 2 --noise-level 2 -i <in image> -o <out image>
```
## Example
```console
$ cd test
$ ls
test.jpg
$ docker run --rm -it -v $(pwd):/work redpeacock78/waifu2x -p 0 -m noise-scale --scale-ratio 2 --noise-level 2 -i test.jpg
CPU: Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz
Processing file [1/1] "/work/test.jpg":
Scaling image from 512x512 to 1024x1024

Step 01/02: Denoising
Proccessing [1/1] slices
Processing block, column (01/02), row (01/02) ...
total : 0.775[sec], 0196.27[GFLOPS]
Processing block, column (02/02), row (01/02) ...
total : 0.058[sec], 0143.44[GFLOPS]
Processing block, column (01/02), row (02/02) ...
total : 0.052[sec], 0160.13[GFLOPS]
Processing block, column (02/02), row (02/02) ...
total : 0.015[sec], 0030.88[GFLOPS]

Step 02/02: 2x Scaling
Proccessing [1/1] slices
2x Scaling:
Processing block, column (01/03), row (01/03) ...
total : 0.870[sec], 0174.87[GFLOPS]
Processing block, column (02/03), row (01/03) ...
total : 0.781[sec], 0194.76[GFLOPS]
Processing block, column (03/03), row (01/03) ...
total : 0.091[sec], 0136.60[GFLOPS]
Processing block, column (01/03), row (02/03) ...
total : 0.753[sec], 0201.92[GFLOPS]
Processing block, column (02/03), row (02/03) ...
total : 0.674[sec], 0225.64[GFLOPS]
Processing block, column (03/03), row (02/03) ...
total : 0.065[sec], 0192.65[GFLOPS]
Processing block, column (01/03), row (03/03) ...
total : 0.061[sec], 0203.08[GFLOPS]
Processing block, column (02/03), row (03/03) ...
total : 0.069[sec], 0180.01[GFLOPS]
Processing block, column (03/03), row (03/03) ...
total : 0.018[sec], 0056.99[GFLOPS]
Writing image to file...

Done, took: 7.452s total, ETA: 0.000s, file: 4.811s avg: 7.452s
Finished processing 1 files
Took: 7.452s total, filter: 4.281s; 0 files skipped, 0 files errored. [GFLOPS: 111.14, GFLOPS-Filter: 4.28]
$ ls
test.jpg 'test_[L2][x2.00].png'
```
- ### Result
|Before (JPEG, 512x512)|After (PNG, 1024x1024)|
|:-:|:-:|
|![before](https://i.imgur.com/pOhBCk3.jpg)|![after](https://i.imgur.com/ex9kU12.png)|


## General Usage
```console
$ docker run --rm -it redpeacock78/waifu2x --help
USAGE: 

   waifu2x-converter-cpp  [--list-supported-formats]
                          [--list-opencv-formats] [-l] [-f <png,jpg,webp
                          ,...>] [-c <0-9>] [-q <0-101>] [--block-size
                          <integer>] [--disable-gpu] [-z] [--force-OpenCL]
                          [-p <integer>] [-j <integer>] [--model-dir
                          <string>] [--scale-ratio <double>] [--noise-level
                          <0|1|2|3>] [-m <noise|scale|noise-scale>] [-v <0
                          |1|2|3|4>] [-s] [-t <bool>] [-g <bool>] [-a
                          <bool>] [-r <bool>] [-o <string>] -i <string>
                          [--] [--version] [-h]


Where: 

   --list-supported-formats
     dump currently supported format list

   --list-opencv-formats
      (deprecated. Use --list-supported-formats) dump opencv supported
     format list

   -l,  --list-processor
     dump processor list

   -f <png,jpg,webp,...>,  --output-format <png,jpg,webp,...>
     The format used when running in recursive/folder mode

     See --list-supported-formats for a list of supported
     formats/extensions.

   -c <0-9>,  --png-compression <0-9>
     Set PNG compression level (0-9), 9 = Max compression (slowest &
     smallest)

   -q <0-101>,  --image-quality <0-101>
     JPEG & WebP Compression quality (0-101, 0 being smallest size and
     lowest quality), use 101 for lossless WebP

   --block-size <integer>
     block size

   --disable-gpu
     disable GPU

   -z,  --resume
     Ignores files in input stream that have already been converted

   --force-OpenCL
     force to use OpenCL on Intel Platform

   -p <integer>,  --processor <integer>
     set target processor

   -j <integer>,  --jobs <integer>
     number of threads launching at the same time

   --model-dir <string>
     path to custom model directory (don't append last / )

   --scale-ratio <double>
     custom scale ratio

   --noise-level <0|1|2|3>
     noise reduction level

   -m <noise|scale|noise-scale>,  --mode <noise|scale|noise-scale>
     image processing mode

   -v <0|1|2|3|4>,  --log-level <0|1|2|3|4>
     Set log level

   -s,  --silent
     Enable silent mode. (same as --log-level 1)

   -t <bool>,  --tta <bool>
     Enable Test-Time Augmentation mode. (0 or 1)

   -g <bool>,  --generate-subdir <bool>
     Generate sub folder when recursive directory is enabled.

     Set 1 to enable this. (0 or 1)

   -a <bool>,  --auto-naming <bool>
     Add postfix to output name when output path is not specified.

     Set 0 to disable this. (0 or 1)

   -r <bool>,  --recursive-directory <bool>
     Search recursively through directories to find more images to
     process.

     If this is set to 0 it will only check in the directory specified if
     the input is a directory instead of an image. (0 or 1)

   -o <string>,  --output <string>
     path to output image file or directory  (you should use the full path)

   -i <string>,  --input <string>
     (required)  path to input image file or directory (you should use the
     full path)

   --,  --ignore_rest
     Ignores the rest of the labeled arguments following this flag.

   --version
     Displays version information and exits.

   -h,  --help
     Displays usage information and exits.


   waifu2x OpenCV Fork - https://github.com/DeadSix27/waifu2x-converter-cpp
```