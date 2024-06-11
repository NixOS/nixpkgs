{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchzip
, androidenv
, makeWrapper
}:
let
version = "2.5.1";
apk = stdenv.mkDerivation {
  pname = "gnirehtet.apk";
  inherit version;
  src = fetchzip {
    url = "https://github.com/Genymobile/gnirehtet/releases/download/v${version}/gnirehtet-rust-linux64-v${version}.zip";
    hash = "sha256-e1wwMhcco9VNoBUzbEq1ESbkX2bqTOkCbPmnV9CpvGo=";
  };
  installPhase = ''
    mkdir $out
    mv gnirehtet.apk $out
  '';
};
in
rustPlatform.buildRustPackage rec {
  pname = "gnirehtet";
  inherit version;

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = "gnirehtet";
    rev = "v${version}";
    hash = "sha256-ewLYCZgkjbh6lR9e4iTddCIrB+5dxyviIXhOqlZsLqc=";
  };
  passthru = {
    inherit apk;
  };

  sourceRoot = "${src.name}/relay-rust";

  cargoHash = "sha256-3oVWFMFzYsuCec1wxZiHXW6O45qbdL1npqYrg/m4SPc=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/gnirehtet \
    --set GNIREHTET_APK ${apk}/gnirehtet.apk \
    --set ADB ${androidenv.androidPkgs_9_0.platform-tools}/bin/adb
  '';

  meta = with lib; {
    description = "Reverse tethering over adb for Android";
    mainProgram = "gnirehtet";
    longDescription = ''
      This project provides reverse tethering over adb for Android: it allows devices to use the internet connection of the computer they are plugged on. It does not require any root access (neither on the device nor on the computer).

      This relies on adb, make sure you have the required permissions/udev rules.
    '';
    homepage = "https://github.com/Genymobile/gnirehtet";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # gnirehtet.apk
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.unix;
  };
}

