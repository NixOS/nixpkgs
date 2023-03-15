{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchpatch
, fetchzip
, androidenv
, makeWrapper
}:
let
version = "2.5";
apk = stdenv.mkDerivation {
  pname = "gnirehtet.apk";
  inherit version;
  src = fetchzip {
    url = "https://github.com/Genymobile/gnirehtet/releases/download/v${version}/gnirehtet-rust-linux64-v${version}.zip";
    hash = "sha256-+H35OoTFILnJudW6+hOaLDMVZcraYT8hfJGiX958YLU=";
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
    hash = "sha256-6KBHRgFvHLqPXkMo1ij0D0ERQICCFGvI7EnaJxCwZnI=";
  };

  sourceRoot = "source/relay-rust";

  cargoPatches = [
    (fetchpatch {
      name = "fix-trailing-semicolon-in-macro.patch";
      url = "https://github.com/Genymobile/gnirehtet/commit/537b3d87344a456e1310f10dcef37592063f4e54.patch";
      hash = "sha256-6U4ZEcqyXcXrfLRtynepS7gp+Uh5sujRyHVLXbWvpq8=";
      stripLen = 1;
    })
    # Updates Cargo.lock and is needed to apply the subsequent patch
    (fetchpatch {
      name = "prefix-unused-field-with-underscore.patch";
      url = "https://github.com/Genymobile/gnirehtet/commit/2f695503dd80519ce73a80c5aa360b08a97c029d.patch";
      hash = "sha256-YVd1B2PVLRGpJNkKb7gpUQWmccfvYaeAmayOmWg8D+Y=";
      stripLen = 1;
    })
    # https://github.com/Genymobile/gnirehtet/pull/478
    (fetchpatch {
      name = "fix-for-rust-1.64.patch";
      url = "https://github.com/Genymobile/gnirehtet/commit/8eeed2084d0d1e2f83056bd11622beaa1fa61281.patch";
      hash = "sha256-Wwc+4vG48/qpusGjlE+mSJvvarYq2mQ2CkDkrtKHAwo=";
      stripLen = 1;
    })
  ];

  cargoHash = "sha256-3iYOeHIQHwxmh8b8vKUf5fQS2fXP2g3orLquvLXzZwE=";

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

