""" Implement the fill contour using morphological operations algorithm. """

import cv2
import numpy as np

if __name__ == '__main__':
    # load image
    image = cv2.imread("outline_2.png", cv2.IMREAD_GRAYSCALE)

    # threshold
    thresh = cv2.threshold(image, 128, 255, cv2.THRESH_BINARY)[1]

    # apply close morphology
    kernel = np.ones((5, 5), np.uint8)
    thresh = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, kernel)

    # get bounding box coordinates from the one filled external contour
    filled = np.zeros_like(thresh)
    contours = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    contours = contours[0] if len(contours) == 2 else contours[1]
    the_contour = contours[0]
    x, y, w, h = cv2.boundingRect(the_contour)
    cv2.drawContours(filled, [the_contour], 0, 255, -1)

    # display results
    cv2.imshow("ORIGINAL", image)
    cv2.imshow("THRESH", thresh)
    cv2.imshow("FILLED", filled)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
