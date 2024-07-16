#!/usr/bin/env python3

def list_all(mongo_collection):

    doc_list = []

    for doc in mongo_collection.find():
        if doc:
            doc_list.append(doc)
    return doc_list
