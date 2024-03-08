{ lib
, stdenv
, fetchgit
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "edid-decode";
  version = "unstable-2024-01-29";

  outputs = [
    "out"
    "man"
  ];

  src = fetchgit {
    url = "git://linuxtv.org/edid-decode.git";
    rev = "7a27b339cf5ee1ab431431a844418a7f7c16d167";
    hash = "sha256-y+g+E4kaQh6j+3GvHdcVEGQu/zOkGyW/HazUHG0DCxM=";
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
