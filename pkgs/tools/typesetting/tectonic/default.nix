/*
  This file provides the `tectonic-unwrapped` package. On the other hand,
  the `tectonic` package is defined in `./wrapper.nix`, by wrapping
  - [`tectonic-unwrapped`](./default.nix) i.e. this package, and
  - [`biber-for-tectonic`](./biber.nix),
    which provides a compatible version of `biber`.
*/

{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, fontconfig
, harfbuzz
, openssl
, pkg-config
, icu
, fetchpatch2
}:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    sha256 = "sha256-xZHYiaQ8ASUwu0ieHIXcjRaH06SQoB6OR1y7Ok+FjAs=";
  };

  cargoPatches = [
    # fix build with rust 1.80
    (fetchpatch2 {
      url = "https://github.com/tectonic-typesetting/tectonic/commit/6b49ca8db40aaca29cb375ce75add3e575558375.patch";
      hash = "sha256-i1L3XaSuBbsmgOSXIWVqr6EHlHGs8A+6v06kJ3C50sk=";
    })
  ];

  cargoHash = "sha256-Zn+xU6NJOY+jDYrSGsbYGAVqprQ6teEdNvlTNDXuzKs=";

  nativeBuildInputs = [ pkg-config ];

  buildFeatures = [ "external-harfbuzz" ];

  buildInputs = [ icu fontconfig harfbuzz openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

  postInstall = ''
    # Makes it possible to automatically use the V2 CLI API
    ln -s $out/bin/tectonic $out/bin/nextonic
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace dist/appimage/tectonic.desktop \
      --replace Exec=tectonic Exec=$out/bin/tectonic
    install -D dist/appimage/tectonic.desktop -t $out/share/applications/
    install -D dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  doCheck = true;

  meta = with lib; {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    changelog = "https://github.com/tectonic-typesetting/tectonic/blob/tectonic@${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    mainProgram = "tectonic";
    maintainers = with maintainers; [ lluchs doronbehar bryango ];
  };
}
