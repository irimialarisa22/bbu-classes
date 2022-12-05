from load_data import load_data
from loss import init_weights
from subgradient import subgradient_descent, plot_loss, plot_accuracy
import numpy as np


def main():
    x, y = load_data('data/spam.csv')
    weights = np.array(np.zeros([1, 5303], dtype=np.float32))
    new_weights = weights
    weights = init_weights(new_weights)
    weights, inputs, targets, x_iter, y_loss, y_acc = subgradient_descent(y, x, weights)

    plot_loss(x_iter, y_loss)
    plot_accuracy(x_iter, y_acc)


if __name__ == '__main__':
    main()
