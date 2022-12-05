import numpy as np


def hinge_loss(ground_truth, predictions):
    return np.maximum(0, 1 - ground_truth * predictions)


def hinge_subgradient(ground_truth, predictions, inputs):
    if ground_truth * predictions < 1:
        subgradiend = (-ground_truth * inputs)
    else:
        subgradiend = np.zeros(inputs.shape)
    return subgradiend


def loss(weights, inputs, ground_truth):
    predictions = inputs @ weights
    losses = [hinge_loss(gt, y) for gt, y in zip(ground_truth, predictions)]
    return np.mean(losses)


def predictor(weights, inputs):
    return inputs @ weights


def predict(weights, inputs):
    raw_predictions = inputs @ weights
    predicted_labels = (raw_predictions > 0).astype(int)
    predicted_labels[predicted_labels == 0] = -1
    return predicted_labels


def init_weights(weights):
    shape = weights.shape[1]
    val = np.random.randn(shape)
    return val
