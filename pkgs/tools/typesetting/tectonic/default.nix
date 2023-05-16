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
<<<<<<< HEAD
=======
, biber
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, icu
}:

rustPlatform.buildRustPackage rec {
  pname = "tectonic";
<<<<<<< HEAD
  version = "0.14.1";
=======
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    sha256 = "sha256-Cd8YzjU5mCA5DmgLBjg8eVRc87chVVIXinJuf8cNw3o=";
  };

  cargoHash = "sha256-1WjZbmZFPB1+QYpjqq5Y+fDkMZNmWJYIxmMFWg7Tiac=";
=======
    sha256 = "sha256-m2wBZNaepad4eaT/1DTjzAYrDX2wH/7wMfdzPWHQOLI=";
  };

  cargoSha256 = "sha256-pMqwWWmPxJZbJavxSVfjjRd7u9fI2AUZRjHF5SxxqoU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config makeBinaryWrapper ];

  buildInputs = [ icu fontconfig harfbuzz openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Cocoa Foundation ]);

<<<<<<< HEAD
  postInstall = lib.optionalString stdenv.isLinux ''
=======
  # Tectonic runs biber when it detects it needs to run it, see:
  # https://github.com/tectonic-typesetting/tectonic/releases/tag/tectonic%400.7.0
  postInstall = ''
    wrapProgram $out/bin/tectonic \
      --prefix PATH : "${lib.getBin biber}/bin"
  '' + lib.optionalString stdenv.isLinux ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "tectonic";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ lluchs doronbehar ];
  };
}
