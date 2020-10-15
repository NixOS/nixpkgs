{ stdenv, fetchFromGitHub, rustPlatform
, darwin, fontconfig, harfbuzz, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    sha256 = "VHhvdIBFPE5CkWVQ4tzMionUnAkZTucVXl5zp5prgok=";
  };

  cargoSha256 = "/f/suiI5XzI0+lCscsqLZTWU6slHdXgR+5epYpxyU1w=";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ fontconfig harfbuzz openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lluchs maintainers.doronbehar ];
  };
}
