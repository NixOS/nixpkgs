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
def en_core_web_trf():
    return spacy.load("en_core_web_trf")


@pytest.fixture
def doc_en_core_web_trf(en_core_web_trf):
    return en_core_web_trf(en_text)


def test_entities(doc_en_core_web_trf):
    entities = list(map(lambda e: (e.text, e.label_),
                        doc_en_core_web_trf.ents))

    assert entities == [
        ('Sebastian Thrun', 'PERSON'),
        ('Google', 'ORG'),
        ('2007', 'DATE'),
        ('American', 'NORP'),
        ('Thrun', 'PERSON'),
        ('Recode', 'ORG'),
        ('earlier this week', 'DATE'),
    ]


def test_nouns(doc_en_core_web_trf):
    assert [
        chunk.text for chunk in doc_en_core_web_trf.noun_chunks] == [
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


def test_verbs(doc_en_core_web_trf):
    assert [
        token.lemma_ for token in doc_en_core_web_trf if token.pos_ == "VERB"] == [
        'start',
        'take',
        'tell',
        'shake',
        'turn',
        'be',
        'talk',
        'say']
