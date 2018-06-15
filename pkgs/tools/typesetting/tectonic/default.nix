{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper
, darwin, fontconfig, harfbuzz-icu, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "tectonic-${version}";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "v${version}";
    sha256 = "007l0l9xnyayiqiap22zlsp8l9afdw803064cj8inr3q7ckzfcpb";
  };

  cargoSha256 = "0kjy9zrjlrlkr2il62nz35hm1nndyym9dbnas43hzz7y8hdf859k";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ fontconfig harfbuzz-icu openssl ]
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
