import cv2
import numpy as np

if __name__ == '__main__':
    image = cv2.imread("lenna.png")

    if image is None:
        print("ERROR LOADING IMAGE!")
        exit(-1)

    image2yuv = cv2.cvtColor(image, cv2.COLOR_BGR2YUV)
    cv2.imshow("ORIGINAL", image)
    y = image2yuv[:, :, 0]
    u = image2yuv[:, :, 1]
    v = image2yuv[:, :, 2]

    noise = np.zeros_like(y)
    # random content with mean = 128 and std = 20
    noise = cv2.randn(noise, 128, 20)
    cv2.imshow("NOISE", noise)
    # blur the noise a bit, kernel size 3x3 and both sigma's are set to 0.5
    noise = cv2.GaussianBlur(noise, (3, 3), 0.5)
    cv2.imshow("BLURRED NOISE", noise)
    brightness_gain = 0
    contract_gain = 1.7
    y = cv2.addWeighted(y, contract_gain, noise, 1, -128 + brightness_gain)
    y = y.astype(np.uint) * y/255
    y = y.astype(np.uint8)
    u = (u * 0.5 + 128 * .5).astype(np.uint8)
    v = (v * 0.5 + 128 * .5).astype(np.uint8)
    image2yuv = cv2.merge((y, u, v))
    image = cv2.cvtColor(image2yuv, cv2.COLOR_YUV2BGR)
    cv2.imshow("OLD IMAGE", image)
    cv2.waitKey(0)
