import cv2
import numpy as np
from copy import deepcopy


def intersect_matrices(mat1, mat2):
    if not (mat1.shape == mat2.shape):
        return False
    mat_intersect = np.where((mat1 == mat2), mat1, 0)
    return mat_intersect


if __name__ == '__main__':
    image = cv2.imread("outline_1.png", cv2.IMREAD_GRAYSCALE)

    # create a mask of image
    contour = cv2.threshold(image, 200, 255, cv2.THRESH_BINARY)[1]

    # define counter of the contour
    Ac = 255 - contour

    kernel = cv2.getStructuringElement(cv2.MORPH_CROSS, (3, 3))

    # define sample point inside the contour
    xx = 150
    xy = 200

    zero_map = np.zeros_like(image)
    zero_map_width_x0 = deepcopy(zero_map)
    zero_map_width_x0[xx][xy] = 255
    prev_fill = zero_map_width_x0
    # apply dilation morphology operation
    while True:
        dilation = cv2.dilate(prev_fill, kernel)
        clean_dilation = cv2.threshold(dilation, 225, 255, cv2.THRESH_BINARY)[1]
        current_fill = intersect_matrices(clean_dilation, Ac)
        if (prev_fill == current_fill).all():
            break
        prev_fill = current_fill
    final_dilation = current_fill + contour

    cv2.imshow("ORIGINAL", image)
    cv2.imshow("THRESH", contour)
    cv2.imshow("FILLED", final_dilation)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
