import cv2

if __name__ == '__main__':
    image = cv2.imread("opera.png")
    image2gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # define different kernel sizes
    kernel_sizes = [(3, 3), (5, 5), (7, 7)]
    for kernel_size in kernel_sizes:
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, kernel_size)
        # apply morphological gradient to detect edges
        gradient = cv2.morphologyEx(image2gray, cv2.MORPH_GRADIENT, kernel)
        cv2.imshow("ORIGINAL", image)
        cv2.imshow("GRADIENT: ({}, {})".format(kernel_size[0], kernel_size[1]), gradient)
        cv2.waitKey(0)