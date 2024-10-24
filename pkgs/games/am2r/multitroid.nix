{ lib
, fetchzip
, autoPatchelfHook
, makeWrapper

# 32 bit packages inherited from `all-packages.nix`.
, stdenv32Bit
, libX11
, libXext
, libXrandr
, libXxf86vm
, openal
, libGLU
, libglvnd
, libzip
, curl
}:

stdenv32Bit.mkDerivation rec {
  pname = "am2r-multitroid-server";
  version = "1.4.2";

  # Building GameMaker games from source is unfortunately a bit involved, so we use the pre-built binaries instead.
  src = fetchzip {
    url = "https://github.com/milesthenerd/AM2R-Server/releases/download/v${version}/AM2R_Server_${version}_lin.zip";
    sha256 = "sha256-7UaoFcpWxM3DKoTvqGK6DMpCyXVp0pSsOrYDpM5SUkI=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libX11
    libXext
    libXrandr
    libXxf86vm
    openal
    libGLU
    libglvnd
    libzip
    curl
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt}
    cp -r ./* $out/opt

    runHook postInstall
  '';


  preFixup = ''
    # GameMaker games (like this server) link to OpenSSL 1.0.0, which is outdated and insecure.
    # When attempting to link to newer versions, an error is raised at runtime claiming it cannot find
    # the outdated version of OpenSSL, even though it has been patched to link to the newer version.
    # After replacing it with libcurl, versioning is ignored, and the binary starts just fine.
    patchelf $out/opt/AM2R_Server \
      --replace-needed libcrypto.so.1.0.0 libcurl.so \
      --replace-needed libssl.so.1.0.0 libcurl.so

    # An environment variable needs to be set on Mesa to avoid a race related to multithreaded shader compilation.
    # See https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/4181 for more information.
    makeWrapper $out/opt/AM2R_Server $out/bin/AM2R_Server \
       --set "radeonsi_sync_compile" "true"

    ln -s $out/bin/AM2R_Server $out/bin/am2r-server
  '';

  # This contains patches usable from the 'am2r' derivation.
  passthru.client = fetchzip {
    name = "am2r-multitroid-mod.zip";
    url = "https://github.com/milesthenerd/AM2R-Multitroid/releases/download/v${version}/Multitroid${builtins.replaceStrings ["."] ["_"] version}VM_Linux.zip";
    sha256 = "sha256-3rYjwMPmQrfLlyDxoHii1u158fwNnn7S6dX+bkzcyF4=";
    stripRoot = false;

    meta = with lib; {
      description = "A multiplayer client mod for AM2R";
      homepage = "https://github.com/milesthenerd/AM2R-Multitroid";
      # A custom unfree license is used: https://github.com/milesthenerd/AM2R-Multitroid/blob/v1.4.2/LICENSE
      license = licenses.unfreeRedistributable;
    };
  };

  meta = with lib; {
    description = "A multiplayer server for AM2R Multitroid clients";
    homepage = "https://github.com/milesthenerd/AM2R-Server";
    license = licenses.mit;
    platforms = [ "i686-linux" ];
    mainProgram = "AM2R_Server";
    maintainers = with maintainers; [ ivar ];
  };
}
