#!/usr/bin/env python3

def schools_by_topic(mongo_collection, topic):

    doc_list = mongo_collection.find(
        {"topics": topic}
        )
    return [doc for doc in doc_list]
