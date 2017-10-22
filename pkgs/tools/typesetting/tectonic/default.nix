{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper
, fontconfig, harfbuzz-icu, openssl, pkgconfig }:

with rustPlatform;

buildRustPackage rec {
  name = "tectonic-${version}";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "v${version}";
    sha256 = "0k5vkn112bjwh4wnxryzqz79dlja64k7s105mf3yaik136hqnmqv";
  };

  cargoSha256 = "03bqhgz8c4ipdkd3g448bcrr6d188h87vskcfcc3mqlcxg77b8q5";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ fontconfig harfbuzz-icu openssl ];

  # tests fail due to read-only nix store
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = https://tectonic-typesetting.github.io/;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lluchs ];
    platforms = platforms.all;
  };
}
