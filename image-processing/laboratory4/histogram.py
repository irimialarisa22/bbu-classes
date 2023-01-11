import cv2
from matplotlib import pyplot as plt

if __name__ == '__main__':
    images = {}
    histograms = {}
    distances = {}

    img1 = cv2.imread("tom_and_jerry_01.jpg")

    if img1 is None:
        print("ERROR LOADING IMAGE!")
        exit()

    cv2.imshow("IMAGE1:", img1)
    img3 = cv2.imread("tom_and_jerry_03.jpg")
    cv2.imshow("IMAGE3:", img3)
    img2 = cv2.imread("tom_and_jerry_02.jpg")
    cv2.imshow("IMAGE2:", img2)

    # convert images to BGR
    img1 = cv2.cvtColor(img1, cv2.COLOR_BGR2HSV)
    images[0] = img1
    img3 = cv2.cvtColor(img3, cv2.COLOR_BGR2HSV)
    images[2] = img3
    img2 = cv2.cvtColor(img3, cv2.COLOR_BGR2HSV)
    images[1] = img2

    # initilialize histogram arguments
    h_bins = int(256 / 16)
    s_bins = int(256 / 8)
    histSize = [h_bins, s_bins]

    # hue varies from 0 to 179, saturation from 0 to 255
    h_ranges = [0, 180]
    s_ranges = [0, 256]
    ranges = h_ranges + s_ranges  # concat lists
    # Use the 0-th and 1-st channels
    channels = [0, 1]

    # calculate histograms of the 3 images
    # extract a 3D RGB color histogram using 8 bits
    hist_img1 = cv2.calcHist([img1], [0, 1, 2], None, [8, 8, 8],
                             [0, 256, 0, 256, 0, 256])
    cv2.normalize(hist_img1, hist_img1, alpha=0, beta=1, norm_type=cv2.NORM_MINMAX)
    histograms[0] = hist_img1

    hist_img3 = cv2.calcHist([img3], [0, 1, 2], None, [8, 8, 8],
                             [0, 256, 0, 256, 0, 256])
    cv2.normalize(hist_img3, hist_img3, alpha=0, beta=1, norm_type=cv2.NORM_MINMAX)
    histograms[1] = hist_img3

    hist_img2 = cv2.calcHist([img2], [0, 1, 2], None, [8, 8, 8],
                             [0, 256, 0, 256, 0, 256])
    histograms[2] = hist_img2
    cv2.normalize(hist_img2, hist_img2, alpha=0, beta=1, norm_type=cv2.NORM_MINMAX)

    # find the metric value
    metric_val1 = cv2.compareHist(hist_img1, hist_img3,
                                  cv2.HISTCMP_BHATTACHARYYA)  # Bhattacharyya distance, used to measure the “overlap” between the two histograms
    distances[0] = metric_val1

    metric_val2 = cv2.compareHist(hist_img1, hist_img2,
                                  cv2.HISTCMP_BHATTACHARYYA)
    distances[1] = metric_val2

    metric_val3 = cv2.compareHist(hist_img2, hist_img3,
                                  cv2.HISTCMP_BHATTACHARYYA)
    distances[2] = metric_val3
    print(distances)
    fig = plt.figure("RESULTS:")
    for (i, v) in enumerate(distances):
        # show the result
        ax = fig.add_subplot(1, len(images), i + 1)
        ax.set_title("%.2f" % v)
        plt.imshow(images[i])
        plt.axis("off")
    plt.show()

    cv2.waitKey(0)