{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mlocate";
  version = "0.26";

  src = fetchurl {
    url = "https://releases.pagure.org/mlocate/mlocate-${version}.tar.xz";
    sha256 = "0gi6y52gkakhhlnzy0p6izc36nqhyfx5830qirhvk3qrzrwxyqrh";
  };

  makeFlags = [
    "dbfile=/var/cache/locatedb"
  ];

  meta = with lib; {
    description = "Merging locate is an utility to index and quickly search for files";
    homepage = "https://pagure.io/mlocate";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
