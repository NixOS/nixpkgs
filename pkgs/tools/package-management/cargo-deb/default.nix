{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, rust
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oWivGy2azF9zpeZ0UAi7Bxm4iXFWAjcBG0pN7qtkSU8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0j9frvcmy9hydw73v0ffr0bjvq2ykylnpmiw700z344djpaaa08y";

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
