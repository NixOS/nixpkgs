{ stdenv, fetchurl, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = "cargo-deb";
    rev = "v${version}";
    sha256 = "0jjhbs48f0rprzxnfgav6mjbyvcqnr7xq1qgyjxwd61z8g3m8hx8";
  };

  buildInputs = with stdenv; lib.optionals isDarwin [ Security ];

  cargoSha256 = "03z9hq873jfsbssnd3kr5vz9lx9mvhb1navb2glm6kkw1k2zm4d2";

  meta = with stdenv.lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
