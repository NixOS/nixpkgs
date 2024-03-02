{ lib
, stdenv
, fetchgit
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "edid-decode";
  version = "unstable-2022-12-14";

  outputs = [
    "out"
    "man"
  ];

  src = fetchgit {
    url = "git://linuxtv.org/edid-decode.git";
    rev = "e052f5f9fdf74ca11aa1a8edfa62eff8d0aa3d0d";
    hash = "sha256-qNtb/eM7VpS8nRbC/nNm6J9vEWVUSrg7OwNaW1774QY=";
  };

  preBuild = ''
    export DESTDIR=$out
    export bindir=/bin
    export mandir=/share/man
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "EDID decoder and conformance tester";
    homepage = "https://git.linuxtv.org/edid-decode.git";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.all;
    mainProgram = "edid-decode";
  };
}
