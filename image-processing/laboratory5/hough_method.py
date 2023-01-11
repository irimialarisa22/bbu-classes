import math
import cv2 as cv2
import numpy as np

if __name__ == '__main__':
    image = cv2.imread("circles-lines.jpg", cv2.IMREAD_COLOR)

    # LINES
    # detect edges using canny edge
    edges = cv2.Canny(image, 50, 200, None, 3)

    # copy edges to the images that will display the results in BGR
    copy_edges = cv2.cvtColor(edges, cv2.COLOR_GRAY2BGR)

    # apply standard HoughLine transform to detect lines
    lines = cv2.HoughLines(edges, 1, np.pi / 180, 150, None, 0, 0)

    # below we will display the result by drawing lines
    if lines is not None:
        for i in range(0, len(lines)):
            rho = lines[i][0][0]
            theta = lines[i][0][1]
            a = math.cos(theta)
            b = math.sin(theta)
            x0 = a * rho
            y0 = b * rho
            pt1 = (int(x0 + 1000 * (-b)), int(y0 + 1000 * a))
            pt2 = (int(x0 - 1000 * (-b)), int(y0 - 1000 * a))
            cv2.line(copy_edges, pt1, pt2, (0, 0, 255), 3, cv2.LINE_AA)

    cv2.imshow("IMAGE", image)
    cv2.imshow("LINES DETECTION", copy_edges)
    cv2.waitKey()

    # CIRCLES
    copy_image = image
    image2gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    circles = cv2.HoughCircles(image2gray, cv2.HOUGH_GRADIENT, 1.2, 100)

    # ensure at least some circles were found
    if circles is not None:
        # convert the (x, y) coordinates and radius of the circles to integers
        circles = np.round(circles[0, :]).astype("int")
        # loop over the (x, y) coordinates and radius of the circles
        for (x, y, r) in circles:
            # draw the circle in the output image, then draw a rectangle
            # corresponding to the center of the circle
            cv2.circle(copy_image, (x, y), r, (0, 255, 0), 4)
            cv2.rectangle(copy_image, (x - 5, y - 5), (x + 5, y + 5), (0, 128, 255), -1)
    cv2.imshow("CIRCLES DETECTION", copy_image)
    cv2.waitKey(0)
