{ stdenv
, lib
, makeWrapper
, cmake
, pkg-config
, SDL2
, fontconfig
, fetchFromGitHub
, python3
}:
{ valve ? throw ''type valve directory for example nix-env --argstr valve "/home/max/valve" -iA xash3d'' } @ args:
let
  hlsdk = fetchFromGitHub{
    owner = "FWGS";
    repo = "hlsdk-xash3d";
    rev = "e7ef84c83db25f5b5b4c8549069135331b5ceeb2";
    sha256 = "1x76zm5c9nz8a927197vwxskak5lm36zwnpviabwgb9ik367413w";
  };
  xash3d = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "FWGS";
    repo = "xash3d";
    rev = "v0.19.2";
    sha256 = "03s061s13wsrljx2zdnwg2ykbxz8cpz2h0dx1wwgnlq9840f50aq";
  };
in

stdenv.mkDerivation {
  pname = "xash3d";
  version = "0.19.2";
  inherit xash3d hlsdk valve;

  nativeBuildInputs = [
    makeWrapper
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    SDL2
    fontconfig
  ];

  configurePhase =  ''
    cmake -DHL_SDK_DIR=$hlsdk -DXASH_SDL=yes -DXASH_VGUI=no -S $xash3d  -B $name/xash3d ${lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") "-DXASH_64BIT=1"}
    cmake -S $hlsdk -B $name/hlsdk ${lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") "-D64BIT=1"}
  '';

  buildPhase = ''
    make -C $name/xash3d $makeFlags
    make -C $name/hlsdk $makeFlags
  '';

  installPhase = ''
    install -D $name/xash3d/engine/libxash.so $out/bin/libxash.so
    install -D $name/xash3d/game_launch/xash3d $out/bin/xash3d
    install -D $name/xash3d/mainui/libxashmenu64.so $out/bin/libxashmenu${lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")"64"}.so
    install -D $name/hlsdk/cl_dll/client.so $out/bin/cl_dlls/client${lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux")"64"}.so
    install -D $name/hlsdk/dlls/hl.so $out/bin/dlls/hl_i386.so
    ln -s $valve $out/bin/valve
    wrapProgram $out/bin/xash3d --prefix LD_LIBRARY_PATH : $out/bin
  '';

  dontUnpack = true;

  meta = {
    description = "Xash3D Engine is a custom Gold Source engine rewritten from scratch.";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.BarinovMaxim ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
