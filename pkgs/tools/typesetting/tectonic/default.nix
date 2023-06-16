{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, fontconfig
, harfbuzz
, openssl
, pkg-config
, makeBinaryWrapper
, icu
}:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    fetchSubmodules = true;
    sha256 = "sha256-Cd8YzjU5mCA5DmgLBjg8eVRc87chVVIXinJuf8cNw3o=";
  };

  cargoHash = "sha256-1WjZbmZFPB1+QYpjqq5Y+fDkMZNmWJYIxmMFWg7Tiac=";

  nativeBuildInputs = [ pkg-config makeBinaryWrapper ];

  buildInputs = [ icu fontconfig harfbuzz openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  postInstall = lib.optionalString stdenv.isLinux ''
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
