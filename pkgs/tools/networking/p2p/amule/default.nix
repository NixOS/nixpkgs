{ fetchurl, stdenv, zlib, wxGTK, perl, cryptopp, libupnp, gettext
, pkgconfig, makeWrapper }:

stdenv.mkDerivation rec {
  name = "aMule-2.2.6";

  src = fetchurl {
    url = "mirror://sourceforge/amule/${name}.tar.bz2";
    sha256 = "08l1931hcg1ia8yvhgx70hx64mknjnfn6l78m0ja44w13mgjpqvc";
  };

  buildInputs =
    [ zlib wxGTK perl cryptopp libupnp gettext pkgconfig makeWrapper ];

  configureFlags = "--with-crypto-prefix=${cryptopp}";

  postConfigure = ''
    sed -i "src/libs/ec/file_generator.pl"     \
        -es'|/usr/bin/perl|${perl}/bin/perl|g'
  '';

  # aMule will try to `dlopen' libupnp and libixml, so help it
  # find them.
  postInstall = ''
    wrapProgram "$out/bin/amule" \
      --prefix LD_LIBRARY_PATH ":" "${libupnp}/lib"
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

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
