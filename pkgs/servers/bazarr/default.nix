{ stdenv, lib, fetchurl, makeWrapper, unzip, python3, unrar, ffmpeg, nixosTests }:

let
  runtimeProgDeps = [
    ffmpeg
    unrar
  ];
in
stdenv.mkDerivation rec {
  pname = "bazarr";
  version = "1.1.2";

  sourceRoot = ".";

  src = fetchurl {
    url = "https://github.com/morpheus65535/bazarr/releases/download/v${version}/bazarr.zip";
    sha256 = "sha256-cTSRfnMYAyoOoTy0wx8sxqyS92zP6GZu8aH5hRRTxU4=";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  buildInputs = [
    (python3.withPackages (ps: [ ps.lxml ps.numpy ps.gevent ps.gevent-websocket ]))
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
