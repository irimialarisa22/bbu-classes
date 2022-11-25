from random import randint

import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.metrics._regression import mean_squared_error

from regression import loadData
from utils import plot3DdataDYNAMICALLY

if __name__ == '__main__':
    trainInputFeatures, trainOutputs, testFeatures, testRealOutputs = loadData()

    train_outputs = trainOutputs.values
    train_inputs = trainInputFeatures.values
    test_inputs = testFeatures.values
    test_outputs = testRealOutputs.values

    feature1 = []
    feature2 = []
    feature3 = []
    for x, y, z in train_inputs:
        feature1.append(x)
        feature2.append(y)
        feature3.append(z)

    # Creates a list of liked colors
    LIKED_COLORS = list([[r, g, b] for r, g, b, out in zip(feature1, feature2, feature3, train_outputs) if out > 200])

    while True:
        regressor = LinearRegression()
        regressor.fit(train_inputs, train_outputs)
        computed_outputs = regressor.predict(test_inputs)
        print("Mean Squared Error :", mean_squared_error(test_outputs, computed_outputs))

        # PLOT EPOCH DATA
        feature1 = []
        feature2 = []
        feature3 = []
        for x, y, z in train_inputs:
            feature1.append(x)
            feature2.append(y)
            feature3.append(z)
        LIKED_COLORS = list(
            [[r, g, b] for r, g, b, out in zip(feature1, feature2, feature3, train_outputs) if out > 200])
        plot3DdataDYNAMICALLY(feature1, feature2, feature3, train_outputs)
        # PLOT EPOCH DATA

        intercept, weights = regressor.intercept_, regressor.coef_
        w0 = intercept[0]
        w1 = weights[0][0]
        w2 = weights[0][1]
        w3 = weights[0][2]
        print(w0, w1, w2, w3)

        print("THE TOTAL LIKED COLORS NUMBER IS: {}.".format(len(LIKED_COLORS)))
        if len(LIKED_COLORS) > 0:
            index = randint(0, len(LIKED_COLORS))
            color = LIKED_COLORS[index]
            R = [color[0]]
            G = [color[1]]
            B = [color[2]]
            prediction = [w0 + w1 * r + w2 * g + w3 * b for r, g, b in zip(R, G, B)]
        else:
            index = 0
            while True:
                R = [randint(0, 255)]
                G = [randint(0, 255)]
                B = [randint(0, 255)]
                prediction = [w0 + w1 * r + w2 * g + w3 * b for r, g, b in zip(R, G, B)]
                if prediction[0] > 200:
                    break
                if index > 10000:
                    print("Runtime index break\n")
                    break
                index += 1

        print("How much the user would like this color: ",
              prediction)  # prediction should be as close to 255 or above this value in order to be likeable

        forPrint = [(R[0] / 255, G[0] / 255, B[0] / 255)]
        plt.imshow([forPrint])
        plt.show()  # visualize the prediction color and check if you like it :D

        like_score = int(input("How much did you like it? (0-255)"))

        np.append(train_inputs, np.asarray([R, G, B]).reshape([1, -1]))
        np.append(train_outputs, np.asarray([like_score]))

        threshold = 50
        index = 0
        for RGB_tup in train_inputs:
            r = RGB_tup[0]
            g = RGB_tup[1]
            b = RGB_tup[2]
            if abs(r - R) <= threshold and abs(g - G) <= threshold and abs(
                    b - B) <= threshold:  # update the like_score for all the color sufficiently similar to the one just shown to the user
                train_outputs[index] = like_score
            index += 1

        index = 0
        for RGB_tup in test_inputs:
            r = RGB_tup[0]
            g = RGB_tup[1]
            b = RGB_tup[2]
            if abs(r - R) <= threshold and abs(g - G) <= threshold and abs(
                    b - B) <= threshold:  # update the like_score for all the color sufficiently similar to the one just shown to the user
                test_outputs[index] = like_score
            index += 1
