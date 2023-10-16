{ lib
, stdenv
, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "seclists";
  version = "2023.3";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "seclists";
    rev = "upstream/${version}";
    hash = "sha256-mJgCzp8iKzSWf4Tud5xDpnuY4aNJmnEo/hTcuGTaOWM=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin
  '';

  meta = with lib; {
    description = "Seclists packaging for Kali Linux";
    homepage = "https://gitlab.com/kalilinux/packages/seclists/-/archive/upstream/2023.3/seclists-upstream-2023.3.tar.gz";
    license = licenses.mit;
    maintainers = with maintainers; [ Tochiaha ];
    mainProgram = "seclists";
    platforms = platforms.all;
  };
}
