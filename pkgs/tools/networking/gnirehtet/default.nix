{stdenv, rustPlatform, fetchFromGitHub, fetchzip, androidenv, substituteAll}:
let
version = "2.2.1";
apk = stdenv.mkDerivation {
  name = "gnirehtet.apk-${version}";
  src = fetchzip {
    url = "https://github.com/Genymobile/gnirehtet/releases/download/v${version}/gnirehtet-rust-linux64-v${version}.zip";
    sha256 = "1rz2wdjc1y7n8fhskmki1nj0ak80ylxspcsrcdnjkk9r7jbq0kan";
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
      sha256 = "1mv8nq4422k2d766qjqqnqp47qzzbbvlwhdni0k6w4nmd3m5cnd9";
  };
  sourceRoot = "source/relay-rust";
  cargoSha256 = "11qf9n6h6akvb0rbmsgdlfmypkbnas8ss1cs7i8w19mh7524n0v5";

  patchFlags = [ "-p2" ];
  patches = [
    (substituteAll {
      src = ./paths.patch;
      adb = "${androidenv.platformTools}/bin/adb";
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

