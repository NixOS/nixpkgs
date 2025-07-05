import pytest
from openai import OpenAI
import sqlite3
import sqlite_vec
import struct
from typing import List
from unittest.mock import MagicMock, patch


def serialize(vector: List[float]) -> bytes:
    """Helper function to serialize a list of floats into bytes"""
    return struct.pack("%sf" % len(vector), *vector)


@pytest.fixture
def mock_db():
    """Fixture that sets up an in-memory SQLite database with the vector extension"""
    db = sqlite3.connect(":memory:")
    db.enable_load_extension(True)
    sqlite_vec.load(db)
    db.enable_load_extension(False)

    # Create tables
    db.execute("""
        CREATE TABLE sentences(
          id INTEGER PRIMARY KEY,
          sentence TEXT
        )
    """)

    db.execute("""
        CREATE VIRTUAL TABLE vec_sentences USING vec0(
          id INTEGER PRIMARY KEY,
          sentence_embedding FLOAT[1536]
        )
    """)

    yield db
    db.close()


def test_database_setup(mock_db):
    """Test that the database tables are created correctly"""
    # Verify tables exist
    tables = mock_db.execute(
        "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('sentences', 'vec_sentences')"
    ).fetchall()

    assert len(tables) == 2
    assert ('sentences',) in tables
    assert ('vec_sentences',) in tables


def test_embedding_storage(mock_db, monkeypatch):
    """Test that embeddings can be stored and retrieved"""
    # Mock the OpenAI client and its response
    mock_embedding = [0.1] * 1536  # Mock embedding vector

    # Insert test data
    test_sentence = "This is a test sentence"
    with mock_db:
        mock_db.execute("INSERT INTO sentences(id, sentence) VALUES(?, ?)", [1, test_sentence])

        # Store the embedding directly without making API calls
        mock_db.execute(
            "INSERT INTO vec_sentences(id, sentence_embedding) VALUES(?, ?)",
            [1, serialize(mock_embedding)]
        )

    # Verify data was inserted
    result = mock_db.execute("SELECT id, sentence FROM sentences WHERE id = 1").fetchone()
    assert result is not None
    assert result[1] == test_sentence

    # Verify embedding was stored
    vec_result = mock_db.execute("SELECT id FROM vec_sentences WHERE id = 1").fetchone()
    assert vec_result is not None
    assert vec_result[0] == 1


def test_similarity_search(mock_db):
    """Test that similarity search works with mock embeddings"""
    # Insert test data with known embeddings
    test_sentences = [
        (1, "I love programming"),
        (2, "Programming is fun"),
        (3, "The weather is nice today")
    ]

    # Create 1536-dimensional mock embeddings
    def create_mock_embedding(values):
        # Create a 1536-dim vector with the first few values set
        embedding = [0.0] * 1536
        for i, val in enumerate(values):
            if i < len(embedding):
                embedding[i] = val
        return embedding

    # Mock embeddings (first few dimensions set, rest are 0)
    test_embeddings = {
        1: create_mock_embedding([0.9, 0.1, 0.1]),
        2: create_mock_embedding([0.8, 0.2, 0.1]),
        3: create_mock_embedding([0.1, 0.1, 0.9])
    }

    with mock_db:
        # Insert test sentences
        for id, sentence in test_sentences:
            mock_db.execute(
                "INSERT INTO sentences(id, sentence) VALUES(?, ?)",
                [id, sentence]
            )

        # Insert mock embeddings
        for id, embedding in test_embeddings.items():
            mock_db.execute(
                "INSERT INTO vec_sentences(id, sentence_embedding) VALUES(?, ?)",
                [id, serialize(embedding)]
            )

    # Test similarity search with a query similar to the first two sentences
    # Create a 1536-dim query embedding
    query_embedding = [0.0] * 1536
    query_embedding[0] = 0.85
    query_embedding[1] = 0.15
    query_embedding[2] = 0.1

    results = mock_db.execute(
        """
        SELECT vec_sentences.id, distance, sentence
        FROM vec_sentences
        LEFT JOIN sentences ON sentences.id = vec_sentences.id
        WHERE sentence_embedding MATCH ?
        AND k = 2
        ORDER BY distance
        """,
        [serialize(query_embedding)]
    ).fetchall()

    # Verify we get the two most similar sentences
    assert len(results) == 2
    # The first result should be the most similar (smallest distance)
    assert results[0][0] == 1  # ID of first sentence
    assert results[0][2] == "I love programming"
    assert results[1][0] == 2  # ID of second sentence
    assert results[1][2] == "Programming is fun"
