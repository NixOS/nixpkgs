{ stdenv, lib, fetchurl, makeWrapper, unzip, python3, unar, ffmpeg, nixosTests }:

let
  runtimeProgDeps = [
    ffmpeg
    unar
  ];
in
stdenv.mkDerivation rec {
  pname = "bazarr";
<<<<<<< HEAD
  version = "1.2.4";
=======
  version = "1.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/morpheus65535/bazarr/releases/download/v${version}/bazarr.zip";
<<<<<<< HEAD
    sha256 = "sha256-TdBazeY/w9vSEbs/OgRtdoi/riAUai1zrmM/A8ecaWA=";
=======
    sha256 = "sha256-PuVK1jrNjxagESYvgqRBfxzsV/KxFhTdOyliO8smwec=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  buildInputs = [
<<<<<<< HEAD
    (python3.withPackages (ps: [
      ps.lxml
      ps.numpy
      ps.gevent
      ps.gevent-websocket
      ps.pillow
      ps.setuptools
    ]))
=======
    (python3.withPackages (ps: [ ps.lxml ps.numpy ps.gevent ps.gevent-websocket ps.pillow ]))
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ runtimeProgDeps;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{bin,share/${pname}}
    cp -r * "$out/share/${pname}"

    # Add missing shebang and execute perms so that patchShebangs can do its
    # thing.
    sed -i "1i #!/usr/bin/env python3" "$out/share/${pname}/bazarr.py"
    chmod +x "$out/share/${pname}/bazarr.py"

    makeWrapper "$out/share/${pname}/bazarr.py" \
        "$out/bin/bazarr" \
        --suffix PATH : ${lib.makeBinPath runtimeProgDeps}

    runHook postInstall
  '';

  passthru.tests = {
    smoke-test = nixosTests.bazarr;
  };

  meta = with lib; {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ d-xo ];
    platforms = platforms.all;
  };
}
