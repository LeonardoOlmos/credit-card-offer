# Credit card offer

## Description
- Model that is used to classified when a customer that has a credit card with us take or reject an offer. 

## Rollout plan
- Into this [trello](https://trello.com/b/xQLwXKqp/credit-risk) you can find the workflow that was followed to reach an MVP.

## Instructions
 - In order to run the model into your local environment, you will need to clone the repo 
 ```bash
     git clone git@github.com:LeonardoOlmos/credit-card-offer.git
 ```
 - Once the repo was cloned, you will need to install all the required libraries by running:
 ```bash
     pip install -r requirements.txt
 ```
 - Finally you have to open the file with `jupyter-notebooks` or `google-collaboratory` to run it

## Main structure
- Into this repo you will find the next structure

```
├── credit-card-offer
│   ├── README.txt
│   ├── creditcardmarketing.csv
│   ├── creditcardmarketing_db.csv
│   ├── credit_card_offer_classification.ipynb
│   ├── credit_marketing.sql
│   ├── requirements.tx
```

* README: File to add docs to the repo
* creditcarmarketing: Dataset used for the analysis
* creditcarmarketing_db: File used as data source for my database on MySQL
* credit_card_offer_classification: Notebook with the base code
* requirements: File with libraries required
* credit_marketing.sql: Queries required on SQL excercises
