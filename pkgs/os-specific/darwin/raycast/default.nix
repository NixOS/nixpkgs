{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

<<<<<<< HEAD
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "raycast";
  version = "1.57.1";

  src = fetchurl {
    name = "Raycast.dmg";
    url = "https://releases.raycast.com/releases/${finalAttrs.version}/download?build=universal";
    hash = "sha256-ePHaNujW39LjMc+R2TZ1favJXeroHpbeuRNwmv8HgXc=";
=======
stdenvNoCC.mkDerivation rec {
  pname = "raycast";
  version = "1.51.1";

  src = fetchurl {
    # https://github.com/NixOS/nixpkgs/pull/223495
    # official download API: https://api.raycast.app/v2/download
    # this returns an AWS CloudFront signed URL with expiration timestamp and signature
    # the returned URL will always be the latest Raycast which might result in an impure derivation
    # the package maintainer created a repo (https://github.com/stepbrobd/raycast-overlay)
    # to host GitHub Actions to periodically check for updates
    # and re-release the `.dmg` file to Internet Archive (https://archive.org/details/raycast)
    url = "https://archive.org/download/raycast/raycast-${version}.dmg";
    sha256 = "sha256-6U0dsDlIuU4OjgF8lvXbtVQ+xFB54KZpasvd307jca4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Raycast.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Raycast.app
    cp -R . $out/Applications/Raycast.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "Control your tools with a few keystrokes";
    homepage = "https://raycast.app/";
<<<<<<< HEAD
    license = with licenses; [ unfree ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ lovesegfault stepbrobd ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
=======
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ lovesegfault stepbrobd ];
    platforms = platforms.darwin;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
