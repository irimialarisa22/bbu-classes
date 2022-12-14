import cv2
import numpy as np
import skimage


def generate_xshape_matrix(n):
    mat = np.zeros((n, n), np.uint8)
    for i in range(0, n):
        for j in range(0, n):
            if (i + j == n - 1) or (i == j):
                mat[i][j] = 1
    return mat


if __name__ == '__main__':
    image = cv2.imread("building.png")

    image2gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    kernel_cross = cv2.getStructuringElement(cv2.MORPH_CROSS, (5, 5))
    dilation_R1 = cv2.dilate(image2gray, kernel_cross)
    kernel_diamond = skimage.morphology.diamond(2)
    erosion_R1 = cv2.erode(dilation_R1, kernel_diamond)

    kernel_x = generate_xshape_matrix(5)
    dilation_R2 = cv2.dilate(image2gray, kernel_x)
    kernel_square = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
    erosion_R2 = cv2.erode(dilation_R2, kernel_square)

    R = cv2.absdiff(erosion_R2, erosion_R1)

    cv2.imshow("ORIGINAL", image)
    cv2.imshow("CORNERS", R)
    cv2.imshow("EROSION_1", erosion_R1)
    cv2.imshow("EROSION_2", erosion_R2)
    cv2.waitKey(0)

