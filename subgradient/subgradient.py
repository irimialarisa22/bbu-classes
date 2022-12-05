import sys
from loss import predictor, predict, hinge_subgradient, loss
import matplotlib.pyplot as plt
import numpy as np


def subgradient_descent(targets, inputs, weights, alpha=0.5):
    current_best_loss = sys.maxsize
    current_iteration, current_epoch = 0, 0

    x_iter = []
    y_loss = []
    y_acc = []

    while True:
        current_epoch += 1
        indexes = np.arange(targets.shape[0])
        inputs, targets = shuffle(indexes, inputs, targets)
        for i, (ground_truth, x_input) in enumerate(zip(targets, inputs)):
            current_iteration += 1
            if current_iteration % 100 == 0:
                prediction = predict(weights, inputs)
                current_accuracy = np.mean(prediction == targets)
                converged = current_accuracy > .95
                if converged:
                    return weights, inputs, targets, x_iter, y_loss, y_acc
                print("Current epoch: {}".format(current_epoch))
                print("Running iteration: {}".format(current_iteration))
                print("Current loss: {}".format(current_loss))
                print("Current accuracy: {}\n".format(current_accuracy))
                x_iter.append(current_iteration)
                y_loss.append(current_best_loss)
                y_acc.append(current_accuracy)
            x_input = x_input.toarray()
            prediction = predictor(weights, x_input)[0]
            subgradient = hinge_subgradient(ground_truth, prediction, x_input)
            current_weights = np.squeeze(weights - alpha * subgradient)
            current_loss = loss(current_weights, inputs, targets)
            if current_loss < current_best_loss:
                current_best_loss = current_loss
                weights = current_weights
        pass


def shuffle(indexes, inputs, targets):
    np.random.shuffle(indexes)
    targets = targets[indexes]
    inputs = inputs[indexes]
    return inputs, targets


def plot_loss(x, y):
    plt.xlabel("Iterations")
    plt.ylabel("Loss")
    plt.plot(x, y)
    plt.show()


def plot_accuracy(x, y):
    plt.xlabel("Iterations")
    plt.ylabel("Accuracy")
    plt.plot(x, y)
    plt.show()

