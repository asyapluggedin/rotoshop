# UCLA DMA 172 Compressed Cinema
I wrote this rotoscoping program in Fall 2019 for Casey Reas' Compressed Cinema class at UCLA Design | Media Arts. I worked in collaboration with Jimmy Zhi, Stephen Heo, and Seenahm Suriyasat, who used the program to produce [this short animation film](https://www.youtube.com/watch?v=DCEJFAOLlxQ&t=15s). It based on the original [Rotoshop program by Bob Sabiston](https://en.wikipedia.org/wiki/Rotoshop), which was developed to accellerate production on the film A Scanner Darkly.

#### Utility
The original Rotoshop program is designed for digitally creating animation that preserves the autographic quality of hand-drawn animation.

#### How to use
You will first have to extract image frames from the video you would like to rotoscope.
I have not yet included a script in this program to assist with that, so I recommend using ffmpeg.

``` ffmpeg -i example.mov -r 12 $example%03d.png ```

Make sure all your extracted files are in the "input" folder.

To run the program, download Processing 3, which is what I used to write it.
Make sure to edit the code in lines 1 and 2, following the commented out instructions.
Then, you can run it! Happy rotoshopping! Once you hit the "run" button, the program should start and look something like this:

![rotoshop](data/rotoshop.png)

Your hand-drawn frames will save to the "output" folder. You can use ffmpeg again to stitch them back into a video format.

