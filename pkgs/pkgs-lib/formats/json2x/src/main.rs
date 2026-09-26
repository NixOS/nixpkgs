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
    /// convert only value of this attribute
    #[argh(option)]
    unwrap: Option<String>,
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

    let json_text = read_to_string(&args.input)
        .with_context(|| format!("failed to read {}", args.input.display()))?;
    let parsed_json: serde_json::Value = serde_json::from_str(&json_text)
        .with_context(|| format!("failed to parse {}", args.input.display()))?;
    let output_value = if let Some(unwrap_key) = args.unwrap {
        parsed_json
            .as_object()
            .ok_or_else(|| anyhow::anyhow!("{} does not contain an object", args.input.display()))?
            .get(&unwrap_key)
            // The key is missing from structured attrs when the value is null, treat missing value as Value::Null.
            .unwrap_or(&serde_json::Value::Null)
    } else {
        &parsed_json
    };
    let mut output = File::create(&args.output)
        .with_context(|| format!("failed to create {}", args.output.display()))?;

    match args.format {
        Format::Toml => {
            let content =
                toml::to_string(output_value).context("failed to serialize value to toml")?;
            output
                .write_all(content.as_bytes())
                .with_context(|| format!("failed to write to {}", args.output.display()))?;
        }
    }

    Ok(())
}
