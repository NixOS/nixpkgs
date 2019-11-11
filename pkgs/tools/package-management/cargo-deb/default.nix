{ stdenv, fetchurl, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = "cargo-deb";
    rev = "v${version}";
    sha256 = "10b25a0cnrd2bhf38yqc32l06vp6sdlfcpa6n9718yipp7b60cq2";
  };

  buildInputs = with stdenv; lib.optionals isDarwin [ Security ];

  cargoSha256 = "182ayprs2awmz7lzqkhawrmpfjla3jcj58q8g8c908gchkh05kns";

  meta = with stdenv.lib; {
    description = "Generate Debian packages from information in Cargo.toml";
    homepage = "https://github.com/mmstick/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
