{ fetchurl, stdenv, zlib, wxGTK, perl, cryptopp, gettext }:

stdenv.mkDerivation rec {
  name = "aMule-2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/amule/${name}.tar.bz2";
    sha256 = "0zcsyy6bm7ls1dpmfm0yskd2gj50ah2bvkm0v42826zwzj6sbxy9";
  };

  buildInputs = [ zlib wxGTK perl cryptopp gettext ];

  configureFlags = "--with-crypto-prefix=${cryptopp}";

  postConfigure = ''
    sed -i "src/libs/ec/file_generator.pl"     \
        -es'|/usr/bin/perl|${perl}/bin/perl|g'
  '';

  meta = {
    homepage = http://amule.org/;
    description = "aMule, a peer-to-peer client for the eD2K and Kademlia networks";

    longDescription = ''
      aMule is an eMule-like client for the eD2k and Kademlia
      networks, supporting multiple platforms.  Currently aMule
      (officially) supports a wide variety of platforms and operating
      systems, being compatible with more than 60 different
      hardware+OS configurations.  aMule is entirely free, its
      sourcecode released under the GPL just like eMule, and includes
      no adware or spyware as is often found in proprietary P2P
      applications.
    '';

    license = "GPLv2+";    
  };
}
