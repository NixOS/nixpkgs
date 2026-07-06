use std::{
    fs::{File, read_to_string},
    io::Write,
    path::PathBuf,
};

use anyhow::Context;
use argh::{FromArgValue, FromArgs};

/// Convert a JSON file to another format
#[derive(FromArgs)]
struct Args {
    /// format of the output file, possible values: toml
    #[argh(positional)]
    format: Format,
    /// path to the input file
    #[argh(positional)]
    input: PathBuf,
    /// path to the output file
    #[argh(positional)]
    output: PathBuf,
}

#[derive(FromArgValue)]
enum Format {
    Toml,
}

fn main() -> anyhow::Result<()> {
    let args: Args = argh::from_env();

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
