use anyhow::Context;
use colored::Colorize;
use std::fs;
use std::io;
use std::path::Path;

/// Deterministic file listing so that tests are reproducible
pub fn read_dir_sorted(base_dir: &Path) -> anyhow::Result<Vec<fs::DirEntry>> {
    let listing = base_dir
        .read_dir()
        .context(format!("Could not list directory {}", base_dir.display()))?;
    let mut shard_entries = listing
        .collect::<io::Result<Vec<_>>>()
        .context(format!("Could not list directory {}", base_dir.display()))?;
    shard_entries.sort_by_key(|entry| entry.file_name());
    Ok(shard_entries)
}

/// A simple utility for calculating the line for a string offset.
/// This doesn't do any Unicode handling, though that probably doesn't matter
/// because newlines can't split up Unicode characters. Also this is only used
/// for error reporting
pub struct LineIndex {
    /// Stores the indices of newlines
    newlines: Vec<usize>,
}

impl LineIndex {
    pub fn new(s: &str) -> LineIndex {
        let mut newlines = vec![];
        let mut index = 0;
        // Iterates over all newline-split parts of the string, adding the index of the newline to
        // the vec
        for split in s.split_inclusive('\n') {
            index += split.len();
            newlines.push(index);
        }
        LineIndex { newlines }
    }

    /// Returns the line number for a string index
    pub fn line(&self, index: usize) -> usize {
        match self.newlines.binary_search(&index) {
            // +1 because lines are 1-indexed
            Ok(x) => x + 1,
            Err(x) => x + 1,
        }
    }
}

/// A small wrapper around a generic io::Write specifically for errors:
/// - Print everything in red to signal it's an error
/// - Keep track of whether anything was printed at all, so that
///   it can be queried whether any errors were encountered at all
pub struct ErrorWriter<W> {
    pub writer: W,
    pub empty: bool,
}

impl<W: io::Write> ErrorWriter<W> {
    pub fn new(writer: W) -> ErrorWriter<W> {
        ErrorWriter {
            writer,
            empty: true,
        }
    }

    pub fn write(&mut self, string: &str) -> io::Result<()> {
        self.empty = false;
        writeln!(self.writer, "{}", string.red())
    }
}
