from random import random

import matplotlib.pyplot as plt


def plot3DdataDYNAMICALLY(RED, GREEN, BLUE, OUT, title=None):
    x1Train, x2Train, yTrain = RED, GREEN, BLUE
    outputs = OUT
    outputs = [o for o in outputs]

    data = list(zip(x1Train, x2Train, yTrain, outputs))
    data.sort(key=lambda x: x[3], reverse=True)

    x1Train = []
    x2Train = []
    yTrain = []
    outputs = []
    for x, y, z, t in data:
        x1Train.append(x)
        x2Train.append(y)
        yTrain.append(z)
        outputs.append(t)

    ax = plt.axes(projection='3d')

    spl = 0
    for spl in range(0, len(outputs)):
        if outputs[spl] < 200:
            break
    print(spl)
    if x1Train:
        plt.scatter(x1Train[:spl], x2Train[:spl], yTrain[:spl], c='g', marker='x', label='color we like')

        r = x1Train[spl:]
        g = x2Train[spl:]
        b = yTrain[spl:]
        r1 = []
        g1 = []
        b1 = []
        for x, y, z in zip(r, g, b):  # show less points (avoid agglomerating the plot)
            if random() > 0.95:
                r1.append(x)
                g1.append(y)
                b1.append(z)

        plt.scatter(r1, g1, b1, c='r', marker='.', label='colors we dislike')
    plt.title(title)

    ax.set_xlabel("RED")
    ax.set_ylabel("GREEN")
    ax.set_zlabel("BLUE")
    plt.legend()
    plt.show()


def plot3DdataINDIVIDUAL_COLORS(RData, GData, BData, title=None):
    ax = plt.axes(projection='3d')

    for R, G, B in zip(RData, GData, BData):
        plt.scatter([R], [G], [B], c=[[R / 255, G / 255, B / 255]], marker='.')

    plt.title(title)
    ax.set_xlabel("RED")
    ax.set_ylabel("GREEN")
    ax.set_zlabel("BLUE")
    plt.legend()
    plt.show()
