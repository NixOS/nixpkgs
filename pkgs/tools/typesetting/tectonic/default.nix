{ stdenv, fetchFromGitHub, rustPlatform
, darwin, fontconfig, harfbuzz, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "v${version}";
    sha256 = "1j98qxlq74vs8nf2jsn2xw9iyrf8kih4v0hrvznkhcab6bpibp2x";
  };

  cargoSha256 = "0hsm5a40lc3gy1zrfrchp7zby17xjv5a4llqr4xmka07y7sk08fn";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ fontconfig harfbuzz openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

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
