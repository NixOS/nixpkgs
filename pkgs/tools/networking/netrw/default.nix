{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "netrw-${version}";
  version = "1.3.2";

  src = fetchurl {
    urls = [
      "http://mamuti.net/files/netrw/netrw-${version}.tar.bz2"
      "http://www.sourcefiles.org/Networking/FTP/Other/netrw-${version}.tar.bz2"
    ];
    sha256 = "1gnl80i5zkyj2lpnb4g0q0r5npba1x6cnafl2jb3i3pzlfz1bndr";
  };

  meta = {
    description = "A simple tool for transporting data over the network.";
    homepage = "http://mamuti.net/netrw/index.en.html";
  };
}
