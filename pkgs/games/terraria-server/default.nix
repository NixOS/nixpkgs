<<<<<<< HEAD
{ lib
, stdenv
, fetchurl

, autoPatchelfHook
, unzip
, zlib
}:
=======
{ stdenv, lib, file, fetchurl, autoPatchelfHook, unzip }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "terraria-server";
  version = "1.4.4.9";
  urlVersion = lib.replaceStrings [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${urlVersion}.zip";
    sha256 = "sha256-Mk+5s9OlkyTLXZYVT0+8Qcjy2Sb5uy2hcC8CML0biNY=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ autoPatchelfHook unzip ];
  buildInputs = [ stdenv.cc.cc.libgcc zlib ];
=======
  buildInputs = [ file ];
  nativeBuildInputs = [ autoPatchelfHook unzip ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r Linux $out/
    chmod +x "$out/Linux/TerrariaServer.bin.x86_64"
    ln -s "$out/Linux/TerrariaServer.bin.x86_64" $out/bin/TerrariaServer

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://terraria.org";
    description = "Dedicated server for Terraria, a 2D action-adventure sandbox";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
<<<<<<< HEAD
    mainProgram = "TerrariaServer";
    maintainers = with maintainers; [ ncfavier tomasajt ];
=======
    maintainers = with maintainers; [ ncfavier ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
