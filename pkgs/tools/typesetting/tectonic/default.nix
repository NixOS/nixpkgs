{ stdenv, fetchFromGitHub, rustPlatform
, darwin, fontconfig, harfbuzz, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "v${version}";
    sha256 = "0dycv135bkpf71iwlwh8rwwvn287d605nl7v8mjxlrsayiivdmn9";
  };

  cargoSha256 = "1axrf7d01gmhvrap13rydfvwcsg0lk1zw7z1i7zzm898bc7c02qn";

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
