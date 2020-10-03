{ stdenv, fetchFromGitHub, rustPlatform
, darwin, fontconfig, harfbuzz, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    sha256 = "0dzqf67y4ci1vsl3zhmjkzfnf22w2bbk5w5qj2gryzrhp1q9ajyr";
  };

  cargoSha256 = "1p0wzylkw1gxaff0m47il7qa0dfflxdyshvkvdirvjidg5cam9bk";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ fontconfig harfbuzz openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lluchs ];
  };
}
