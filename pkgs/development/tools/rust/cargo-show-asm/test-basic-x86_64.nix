{ runCommand, cargo, rustc, cargo-show-asm }:
runCommand "test-basic" {
  nativeBuildInputs = [ cargo rustc cargo-show-asm ];
} ''
  mkdir -p src
  cat >Cargo.toml <<EOF
[package]
name = "add"
version = "0.0.0"
EOF
  cat >src/lib.rs <<EOF
pub fn add(a: u32, b: u32) -> u32 { a + b }
EOF

  [[ "$(cargo asm add::add | tee /dev/stderr)" == *"lea eax, "* ]]
  [[ "$(cargo asm --mir add | tee /dev/stderr)" == *"= Add("* ]]
  touch $out
''
