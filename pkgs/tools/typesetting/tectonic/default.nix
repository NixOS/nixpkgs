{ stdenv, fetchFromGitHub, rustPlatform
, darwin, fontconfig, harfbuzz, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    sha256 = "yJzfymA4elyyeVR8FzTJe8wgs+vm3RWwcOh7IlmBYPE=";
  };

  cargoSha256 = "7zqr54H6GemiM/xuHOH6+s669IG2orj1neoqAH+wnV4=";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ fontconfig harfbuzz openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    install -D dist/appimage/tectonic.desktop -t $out/share/applications/
    install -D dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lluchs maintainers.doronbehar ];
  };
}
