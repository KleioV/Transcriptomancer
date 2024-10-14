#!/usr/bin/env python3
# === ML Predictions with Random Forest and Evaluation ===
# This script loads data, trains a RandomForest classifier, evaluates its performance with ROC curves,
# and computes various classification metrics (accuracy, specificity, sensitivity).

# === Libraries ===
import random
from numpy import genfromtxt
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix, roc_curve, auc
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import RocCurveDisplay
import sklearn.metrics as metrics

# === Seed Initialization ===
# Set seeds for reproducibility
np.random.seed(1)
random.seed('Kleio')

# === Load Data Function ===
def load_data(dataset_path):
    """
    Load the dataset from the given path.
    """
    # Read the dataset as a matrix
    dataset = genfromtxt(dataset_path, delimiter='\t', dtype='str')
    data = dataset[1:, 1:].astype('float')  # Exclude headers and first column
    print(f"Data Shape: {data.shape}")
    
    return data

# === Load Labels Function ===
def load_labels():
    """
    Generate the labels for the dataset. 
    Assume labels are binary (0 for class A, 1 for class I).
    """
    labels = [0] * 594
    labels2 = [1] * 615
    labels.extend(labels2)
    print(f"Labels: {labels}")
    
    return np.array(labels)

# === Train Classifier Function ===
def train_classifier(X_train, y_train):
    """
    Train a RandomForestClassifier and return the trained model.
    """
    classifier = RandomForestClassifier(criterion='gini')
    classifier.fit(X_train, y_train)
    return classifier

# === Evaluate Model Function ===
def evaluate_model(classifier, X_test, y_test):
    """
    Evaluate the trained classifier on the test data.
    This function will plot ROC curves, calculate AUC, and other metrics.
    """
    # Get probabilities for ROC curve
    probs = classifier.predict_proba(X_test)
    preds = probs[:, 1]
    
    # Calculate ROC AUC
    roc_auc = metrics.auc(*roc_curve(y_test, preds)[:2])
    print(f"AUC: {roc_auc:.4f}")

    # ROC curve plot
    RocCurveDisplay.from_estimator(classifier, X_test, y_test)
    plt.savefig('AUC_Test_Est.png')

    # Calculate confusion matrix
    mylist = (preds >= 0.5).astype(int)  # Thresholding prediction at 0.5
    print("Classification Report:")
    print(classification_report(y_test, mylist))
    
    tn, fp, fn, tp = confusion_matrix(y_test, mylist).ravel()
    specificity = tn / (tn + fp)
    sensitivity = tp / (tp + fn)
    print(f"Specificity: {specificity:.4f}")
    print(f"Sensitivity: {sensitivity:.4f}")
    
    accuracy = accuracy_score(y_test, mylist)
    print(f"Accuracy: {accuracy:.4f}")

    # Generate and save the ROC curve plot
    fpr, tpr, _ = roc_curve(y_test, preds)
    plt.figure()
    plt.title('Receiver Operating Characteristic')
    plt.plot(fpr, tpr, 'b', label=f'AUC = {roc_auc:.2f}')
    plt.legend(loc='lower right')
    plt.plot([0, 1], [0, 1], 'r--')
    plt.xlim([0, 1])
    plt.ylim([0, 1])
    plt.ylabel('True Positive Rate')
    plt.xlabel('False Positive Rate')
    plt.savefig('AUC_Test3.png')

# === Main Function ===
def main():
    # Load the data and labels
    data = load_data('path/to/Counted_Batch1_2_RawRead_PC_ranked_Trans.txt')
    labels = load_labels()
    
    # Split the data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(data, labels, test_size=0.1, random_state=0)
    
    # Train the classifier
    classifier = train_classifier(X_train, y_train)

    # Evaluate the model
    evaluate_model(classifier, X_test, y_test)

# Run the main function
if __name__ == "__main__":
    main()
