{ stdenv, fetchurl
, checksumType ? "built-in"
, libmhash ? null
, openssl ? null
}:

assert checksumType == "mhash" -> libmhash != null;
assert checksumType == "openssl" -> openssl != null;

stdenv.mkDerivation rec {
  name = "netrw-${version}";
  version = "1.3.2";

  configureFlags = [
    "--with-checksum=${checksumType}"
  ];

  buildInputs = stdenv.lib.optional (checksumType == "mhash") libmhash
             ++ stdenv.lib.optional (checksumType == "openssl") openssl;

  src = fetchurl {
    urls = [
      "http://mamuti.net/files/netrw/netrw-${version}.tar.bz2"
      "http://www.sourcefiles.org/Networking/FTP/Other/netrw-${version}.tar.bz2"
    ];
    sha256 = "1gnl80i5zkyj2lpnb4g0q0r5npba1x6cnafl2jb3i3pzlfz1bndr";
  };

  meta = {
    description = "Simple tool for transporting data over the network";
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://mamuti.net/netrw/index.en.html";
  };
}
