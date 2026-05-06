use std::{
    fs::{File, read_to_string},
    io::Write,
    path::PathBuf,
};

use anyhow::Context;
use clap::{Parser, ValueEnum};

#[derive(Parser)]
struct Args {
    format: Format,
    input: PathBuf,
    output: PathBuf,
}

#[derive(Clone, ValueEnum)]
enum Format {
    Toml,
}

fn main() -> anyhow::Result<()> {
    let args = Args::parse();

    let input = read_to_string(&args.input)
        .with_context(|| format!("failed to read {}", args.input.display()))?;
    let input: serde_json::Value = serde_json::from_str(&input)
        .with_context(|| format!("failed to parse {}", args.input.display()))?;
    let mut output = File::create(&args.output)
        .with_context(|| format!("failed to create {}", args.output.display()))?;

    match args.format {
        Format::Toml => {
            let content = toml::to_string(&input).context("failed to serialize value to toml")?;
            output
                .write_all(content.as_bytes())
                .with_context(|| format!("failed to write to {}", args.output.display()))?;
        }
    }

    Ok(())
}
