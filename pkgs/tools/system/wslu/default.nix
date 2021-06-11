{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "wslu";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "wslutilities";
    repo = pname;
    rev = "v${version}";
    sha512 = "2mkvdl65hnwflmi635ngmsm1aqsablz2gypn3a1adby1mwwdc57xym8kkg5359g3mvksac6n43ji2z48lfpvlay64z793q2v0z6by02";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A collection of utilities for Windows 10 Linux Subsystems";
    homepage = "https://github.com/wslutilities/wslu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    platforms = platforms.linux;
  };
}
