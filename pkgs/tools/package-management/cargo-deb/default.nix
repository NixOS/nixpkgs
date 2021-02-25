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
    rev = "86d02f9cacaf4a4f9b576e2dbd9dad65baa61a0d";
    sha256 = "sha256-oWivGy2azF9zpeZ0UAi7Bxm4iXFWAjcBG0pN7qtkSU8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "sha256-HgGl1JWNkPEBODzWa6mfXuAtF8jOgT0Obx4mX9nOLkk=";

  preCheck = ''
    substituteInPlace tests/command.rs \
      --replace 'target/debug' "target/${rust.toRustTarget stdenv.buildPlatform}/release"
  '';

  meta = with lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
