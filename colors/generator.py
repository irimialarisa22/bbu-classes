from random import randint
from random import random


def generateComplete_RGB_and_OUT(fileNames, how_many, rangeRGB_LIKE):
    """
	@param fileNames: LIST of files: first if the input_file_name and the second is the output_file_name
	@param how_manys: INTEGER: how many data values the two files will have (will be same value in both)
	@param rangeRGB: LIST of 3 INTERVALS (limits for intervals are [0..255])
	The intervals are represented as lists [lower_bound, upper_bound].
	"""
    rangeR = rangeRGB_LIKE[0]  # like intervals (anything outside is dislike)
    rangeG = rangeRGB_LIKE[1]
    rangeB = rangeRGB_LIKE[2]

    f = open(fileNames[0], "w")  # input file
    g = open(fileNames[1], "w")  # output file

    for _ in range(0, how_many):  # generate data
        R = randint(0, 255)
        G = randint(0, 255)
        B = randint(0, 255)  # create a random color

        f.write(str(R))  # write it to file
        f.write(', ')
        f.write(str(G))
        f.write(', ')
        f.write(str(B))
        f.write('\n')

        if R in range(rangeR[0], rangeR[1] + 1) and G in range(rangeG[0], rangeG[1] + 1) and B in range(rangeB[0],
                                                                                                        rangeB[1] + 1):
            # if the R,G and B values of the generated colors are in the like interval, then write maximum score in the output file
            g.write(str(255))
        else:
            # else, it means we do not like the color, therefore the score is 0.
            g.write(str(0))
        g.write('\n')

        if random() > 0.75:  # generate additional liked data (boost start prediction confidence
            R = randint(rangeR[0], rangeR[1])
            G = randint(rangeG[0], rangeG[1])
            B = randint(rangeB[0], rangeB[1])  # create a random LIKED color

            f.write(str(R))  # write it to file
            f.write(', ')
            f.write(str(G))
            f.write(', ')
            f.write(str(B))
            f.write('\n')

            g.write(str(255))
            g.write('\n')

    f.close()  # close the files
    g.close()


if __name__ == '__main__':
    generateComplete_RGB_and_OUT(["train_DATA.txt", "train_OUT.txt"], 10000, [[66, 66], [120, 245], [200, 245]])
    generateComplete_RGB_and_OUT(["test_DATA.txt", "test_OUT.txt"], 1000, [[66, 66], [120, 245], [200, 245]])
