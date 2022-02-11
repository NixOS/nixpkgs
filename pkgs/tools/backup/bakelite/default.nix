{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bakelite";
  version = "unstable-2021-10-19";

  src = fetchFromGitHub {
    owner = "richfelker";
    repo = pname;
    rev = "5fc3cf9704dbaa191b95f97d2a700588ea878a36";
    sha256 = "xoGor8KMG1vU6hP6v6gHcADKjVpaClvkivxkcPUJtss=";
  };

  hardeningEnable = [ "pie" ];
  buildFlags = [ "CFLAGS=-D_GNU_SOURCE" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bakelite $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/richfelker/bakelite";
    description = "Incremental backup with strong cryptographic confidentality";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvs ];
  };
}
