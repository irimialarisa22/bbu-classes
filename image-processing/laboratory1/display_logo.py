""" Write an application that loads a scene image and a logo image and superposes the logo image over the scene and
allows to see through the zones in the logo that do not contain details/information. """

import cv2
import numpy as np

if __name__ == '__main__':
    # read logo and resize
    logo = cv2.imread("opencv-logo.png")
    size = 200
    logo = cv2.resize(logo, (size, size))
    cv2.imshow("IMAGE", logo)
    cv2.waitKey(0)

    # create a mask of logo
    image2gray = cv2.cvtColor(logo, cv2.COLOR_RGB2GRAY)
    cv2.imshow("IMAGE_RGB2GRAY", image2gray)
    image2gray = cv2.cvtColor(logo, cv2.COLOR_BGR2GRAY)
    cv2.imshow("IMAGE_BGR2GRAY", image2gray)
    ret, contour = cv2.threshold(image2gray, 1, 255, cv2.THRESH_BINARY)

    # setup camera
    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        print("ERROR OPENING DEVICE CAMERA")
        exit(-1)
    while True:
        # capture frame-by-frame
        ret, frame = cap.read()

        # flip the frame horizontally
        frame = cv2.flip(frame, 1)

        # region of interest (ROI), where we want to insert logo
        roi = frame[-size-10:-10, -size-10:-10]

        # set an index of where the mask is
        roi[np.where(contour)] = 0
        roi += logo

        # display the resulting frame
        cv2.imshow("CAMERA", frame)

        if cv2.waitKey(1) == ord('q'):
            break

    # when everything done, release the capture
    cap.release()
    cv2.destroyAllWindows()