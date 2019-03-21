{stdenv, rustPlatform, fetchFromGitHub, fetchzip, androidenv, substituteAll}:
let
version = "2.3";
apk = stdenv.mkDerivation {
  name = "gnirehtet.apk-${version}";
  src = fetchzip {
    url = "https://github.com/Genymobile/gnirehtet/releases/download/v${version}/gnirehtet-rust-linux64-v${version}.zip";
    sha256 = "08pgmpbz82cd8ndr2syiv25l5xk1gvh9gzji4pgva5gw269bjmpz";
  };
  installPhase = ''
    mkdir $out
    mv gnirehtet.apk $out
  '';
};
in
rustPlatform.buildRustPackage rec {
  name = "gnirehtet-${version}";

  src = fetchFromGitHub {
      owner = "Genymobile";
      repo = "gnirehtet";
      rev = "v${version}";
      sha256 = "118ig42qzr2xyra7r8zfxq38xidaxfc98ja9836jwnn9fgbigczr";
  };
  sourceRoot = "source/relay-rust";
  cargoSha256 = "0370jbllahcdhs132szbxb2yr675s5smm74sx58qi8jhykbb5qs7";

  patchFlags = [ "-p2" ];
  patches = [
    (substituteAll {
      src = ./paths.patch;
      adb = "${androidenv.androidPkgs_9_0.platform-tools}/bin/adb";
      inherit apk;
    })
  ];

  meta = with stdenv.lib; {
    description = "Reverse tethering over adb for Android";
    longDescription = ''
      This project provides reverse tethering over adb for Android: it allows devices to use the internet connection of the computer they are plugged on. It does not require any root access (neither on the device nor on the computer).

      This relies on adb, make sure you have the required permissions/udev rules.
    '';
    homepage = https://github.com/Genymobile/gnirehtet;
    license = licenses.asl20;
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.unix;
  };
}

