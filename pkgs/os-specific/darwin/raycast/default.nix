{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "raycast";
  version = "1.50.0";

  src = fetchurl {
    # https://github.com/NixOS/nixpkgs/pull/223495
    # official download API: https://api.raycast.app/v2/download
    # this returns an AWS CloudFront signed URL with expiration timestamp and signature
    # the returned URL will always be the latest Raycast which might result in an impure derivation
    # the package maintainer created a repo (https://github.com/stepbrobd/raycast-overlay)
    # to host GitHub Actions to periodically check for updates
    # and re-release the `.dmg` file to Internet Archive (https://archive.org/details/raycast)
    url = "https://archive.org/download/raycast/raycast-${version}.dmg";
    sha256 = "sha256-+LvQDQZjbj/p8VT/af9XwKSKkKd65YzcwrKF9hoXCog=";
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
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ lovesegfault stepbrobd ];
    platforms = platforms.darwin;
  };
}
