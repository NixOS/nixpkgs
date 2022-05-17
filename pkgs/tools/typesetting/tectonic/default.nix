{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, fontconfig
, harfbuzz
, openssl
, pkg-config
, makeWrapper
, biber
, icu
}:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    fetchSubmodules = true;
    sha256 = "mfIEfue64kG4NmIEdTPRAqt6y22XfcgH6GtvJxuH6TU=";
  };

  cargoSha256 = "CH1FdZ7cPrE0V0yjauOjDKrRNioC3MjtcnZaOTkMptc=";

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ icu fontconfig harfbuzz openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  # Tectonic runs biber when it detects it needs to run it, see:
  # https://github.com/tectonic-typesetting/tectonic/releases/tag/tectonic%400.7.0
  postInstall = ''
    wrapProgram $out/bin/tectonic \
      --prefix PATH "${lib.getBin biber}/bin"
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace dist/appimage/tectonic.desktop \
      --replace Exec=tectonic Exec=$out/bin/tectonic
    install -D dist/appimage/tectonic.desktop -t $out/share/applications/
    install -D dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/

    ln -s $out/bin/tectonic $out/bin/nextonic
  '';

  doCheck = true;

  meta = with lib; {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    changelog = "https://github.com/tectonic-typesetting/tectonic/blob/tectonic@${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lluchs doronbehar ];
  };
}
