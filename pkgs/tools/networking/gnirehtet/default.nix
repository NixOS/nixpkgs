{stdenv, rustPlatform, fetchFromGitHub, fetchzip, androidenv, substituteAll}:
let
version = "2.4";
apk = stdenv.mkDerivation {
  pname = "gnirehtet.apk";
  inherit version;
  src = fetchzip {
    url = "https://github.com/Genymobile/gnirehtet/releases/download/v${version}/gnirehtet-rust-linux64-v${version}.zip";
    sha256 = "13gsh5982v961j86j5y71pgas94g2d1v1fgnbslbqw4h69fbf48g";
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
      sha256 = "1c99d6zpjxa8xlrg0n1825am20d2pjiicfcjwv8iay9ylfdnvygl";
  };
  sourceRoot = "source/relay-rust";
  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1l1cirhmfkpa466vksynlhwggsfiahws7cpsxydrc414l415l283";

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

