{ stdenv, fetchFromGitHub, rustPlatform
, darwin, fontconfig, harfbuzz, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "tectonic-${version}";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "v${version}";
    sha256 = "1j98qxlq74vs8nf2jsn2xw9iyrf8kih4v0hrvznkhcab6bpibp2x";
  };

  cargoSha256 = "1zgav5zxfvdnrr7himykj5ha20cb5ldxpcpl8y6d19dirxvcmpc6";

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
