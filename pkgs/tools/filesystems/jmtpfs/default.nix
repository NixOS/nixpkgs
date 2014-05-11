{ stdenv, fetchurl
, autoconf, automake
, unzip, pkgconfig
, file, fuse, libmtp }:

stdenv.mkDerivation rec {
  version = "0.5";
  name = "jmtpfs-${version}";

  rev = "928fb8f2eec34232e3b2cecc121195caa8865e15";

  src = fetchurl {
    url = "https://github.com/JasonFerrara/jmtpfs/archive/${rev}.zip";
    sha256 = "11904f8pkb84gah0h1m7s1hwkp9wa6dzcjj6d8nk4r37lqbillxc";
  };

  buildInputs = [ autoconf automake file fuse libmtp pkgconfig unzip ];

  meta = {
    description = "A FUSE filesystem for MTP devices like Android phones.";
    homepage = https://github.com/JasonFerrara/jmtpfs;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.coconnor ];
  };
}
