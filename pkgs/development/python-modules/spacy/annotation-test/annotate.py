import pytest
import spacy

en_text = (
    "When Sebastian Thrun started working on self-driving cars at "
    "Google in 2007, few people outside of the company took him "
    "seriously. “I can tell you very senior CEOs of major American "
    "car companies would shake my hand and turn away because I wasn’t "
    "worth talking to,” said Thrun, in an interview with Recode earlier "
    "this week.")


@pytest.fixture
def en_core_web_sm():
    return spacy.load("en_core_web_sm")


@pytest.fixture
def doc_en_core_web_sm(en_core_web_sm):
    return en_core_web_sm(en_text)


def test_entities(doc_en_core_web_sm):
    entities = list(map(lambda e: (e.text, e.label_),
                        doc_en_core_web_sm.ents))

    assert entities == [
        ('Sebastian Thrun', 'PERSON'),
        ('Google', 'ORG'),
        ('2007', 'DATE'),
        ('American', 'NORP'),
        ('Thrun', 'GPE'),
        ('Recode', 'ORG'),
        ('earlier this week', 'DATE'),
    ]


def test_nouns(doc_en_core_web_sm):
    assert [
        chunk.text for chunk in doc_en_core_web_sm.noun_chunks] == [
        'Sebastian Thrun',
        'self-driving cars',
        'Google',
        'few people',
        'the company',
        'him',
        'I',
        'you',
        'very senior CEOs',
        'major American car companies',
        'my hand',
        'I',
        'Thrun',
        'an interview',
        'Recode']


def test_verbs(doc_en_core_web_sm):
    assert [
        token.lemma_ for token in doc_en_core_web_sm if token.pos_ == "VERB"] == [
        'start',
        'work',
        'drive',
        'take',
        'tell',
        'shake',
        'turn',
        'talk',
        'say']
