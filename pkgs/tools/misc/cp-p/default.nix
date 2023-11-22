{ lib
, stdenv
, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "cp-p";
  version = "unstable-2022-08-07";

  src = fetchFromGitHub {
    owner = "Naheel-Azawy";
    repo = "cp-p";
    rev = "2e97ba534a5892c47a0317a038b19bcda221e5e6";
    sha256 = "1ki8bp33d9xf4jinr0isvkxq3i86xi1kkv2f5x54as6i0yz9w7iq";
  };
  
  # this cancels automatic make
  dontBuild = true;
  
  installPhase = ''
    mkdir -p $out/bin
    cp cp-p mv-p $out/bin/
  '';

  meta = {
    homepage = "https://github.com/Naheel-Azawy/cp-p";
    description = "cp (and mv), with progress";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
   }; 
}
