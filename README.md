# Parallel multiplier based on BOOTH’s algorithm

Booth's algorithm is a procedure for the multiplication of two signed binary numbers in two's complement notation. 
This code is a structural\behavioral implementation of the N bit Booth's multiplier in VHDL.

![Alt text](/img/BOOTH_img.jpg?raw=true "BOOTH_add")

## Organization

The main structure of the file called BOOTHMUL is based on the replication of a base block (booth_add), which allows the application of the algorithm.
This structure is shown below in the image.

![Alt text](/img/BOOTH_add_img.jpg?raw=true "BOOTH_add")

In this case the encoder is based on the choice of a MUX and the various choices are only 3 since the negative element will not be passed directly but will be chosen whether to subtract or sum the outputs of the MUX.
The presence of the FA is used to manage cases in which in the algorithm the entering number, in binary form, has a 1 as the first element.
The final result will be on a size of 2N considered in two pieces of N bit.
The lower N bits are composed of the collection of the two-bit outputs of each sub-block.
The most N bits arrive from the SUM_OUT output of the last step.
For the first step SUM_IN is equal to all 0's.
