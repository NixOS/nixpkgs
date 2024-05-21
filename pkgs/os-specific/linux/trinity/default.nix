{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "trinity";
  version = "1.9-unstable-2023-07-10";

  src = fetchFromGitHub {
    owner = "kernelslacker";
    repo = "trinity";
    rev = "e71872454d26baf37ae1d12e9b04a73d64179555";
    hash = "sha256-Zy+4L1CuB2Ul5iF+AokDkAW1wheDzoCTNkvRZFGRNps=";
  };

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts
  '';

  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "A Linux System call fuzz tester";
    mainProgram = "trinity";
    homepage = "https://github.com/kernelslacker/trinity";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
