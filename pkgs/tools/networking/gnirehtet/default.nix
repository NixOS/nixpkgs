{ lib, stdenv, rustPlatform, fetchFromGitHub, fetchzip, androidenv, makeWrapper }:
let
version = "2.5";
apk = stdenv.mkDerivation {
  pname = "gnirehtet.apk";
  inherit version;
  src = fetchzip {
    url = "https://github.com/Genymobile/gnirehtet/releases/download/v${version}/gnirehtet-rust-linux64-v${version}.zip";
    sha256 = "1db0gkg5z8lighhkyqfsr9jiacrck89zmfnmp74vj865hhxgjzgq";
  };
  installPhase = ''
    mkdir $out
    mv gnirehtet.apk $out
  '';
};
in
rustPlatform.buildRustPackage {
  pname = "gnirehtet";
  inherit version;

  src = fetchFromGitHub {
      owner = "Genymobile";
      repo = "gnirehtet";
      rev = "v${version}";
      sha256 = "0wk6n082gnj9xk46n542h1012h8gyhldca23bs7vl73g0534g878";
  };
  sourceRoot = "source/relay-rust";
  cargoSha256 = "03r8ivsvmhi5f32gj4yacbyzanziymszya18dani53bq9zis9z31";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/gnirehtet \
    --set GNIREHTET_APK ${apk}/gnirehtet.apk \
    --set ADB ${androidenv.androidPkgs_9_0.platform-tools}/bin/adb
  '';

  meta = with lib; {
    description = "Reverse tethering over adb for Android";
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

