import numpy as np
from gensim.parsing.preprocessing import preprocess_string
from sklearn.feature_extraction.text import CountVectorizer


def parse_text(line):
    fields = line.strip().split(',')
    return preprocess_string(fields[1])


def get_texts(lines):
    """
    :param lines: array of text messages
    :return: list of tuples obtained from hashing the @lines using the hash function "parse_text".
    """
    return list(map(parse_text, lines))


def convert_label(line, label_dict):
    """
    :param line: array containing string label and text message
    :param label_dict: dict for mapping from string to integer of the true labels
    :return: 1 if true label is "ham" and -1 if true label is "spam"
    """
    fields = line.strip().split(',')
    key = preprocess_string(fields[0])[0]
    return label_dict[key]


def get_labels(lines, label_dict):
    """
    :param lines: raw message data (string label + text message)
    :param label_dict: dict for mapping the labels
    :return: list of all the messages with correspondingly mapped labels
    """
    return list(map(lambda x: convert_label(x, label_dict), lines))


def load_data(file):
    lines = open(file, 'r', encoding='ISO-8859-1').readlines()
    lines = lines[1:]  # remove header line
    label_dict = {'ham': 1, 'spam': -1}
    y = get_labels(lines, label_dict)
    texts = get_texts(lines)
    texts = [' '.join(x) for x in texts]
    bow = CountVectorizer()
    X = bow.fit_transform(texts)
    return X, np.array(y)

