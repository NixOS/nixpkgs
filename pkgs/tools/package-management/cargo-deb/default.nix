{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, rust
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2eOWhxKZ+YPj5oKTe5g7PyeakiSNnPz27dK150GAcVQ=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-QmchuY+4R7w0zMOdReH1m8idl9RI1hHE9VtbwT2K9YM=";

  preCheck = ''
    substituteInPlace tests/command.rs \
      --replace 'target/debug' "target/${rust.toRustTarget stdenv.buildPlatform}/release"

    # This is an FHS specific assert depending on glibc location
    substituteInPlace src/dependencies.rs \
      --replace 'assert!(deps.iter().any(|d| d.starts_with("libc")));' '// no libc assert here'
  '';

  meta = with lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
