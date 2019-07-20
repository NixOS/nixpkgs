{ monolithic ? true # build monolithic amule
, daemon ? false # build amule daemon
, httpServer ? false # build web interface for the daemon
, client ? false # build amule remote gui
, fetchurl, stdenv, zlib, wxGTK, perl, cryptopp, libupnp, gettext, libpng ? null
, pkgconfig, makeWrapper, libX11 ? null }:

assert httpServer -> libpng != null;
assert client -> libX11 != null;
with stdenv;

mkDerivation rec {
  name = "aMule-2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/amule/${name}.tar.xz";
    sha256 = "0a1rd33hjl30qyzgb5y8m7dxs38asci3kjnlvims1ky6r3yj0izn";
  };

  buildInputs =
    [ zlib wxGTK perl cryptopp libupnp gettext pkgconfig makeWrapper ]
    ++ lib.optional httpServer libpng
    ++ lib.optional client libX11;

  # See: https://github.com/amule-project/amule/issues/126
  patches = [ ./upnp-1.8.patch ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-crypto-prefix=${cryptopp}"
    "--disable-debug"
    "--enable-optimize"
    (stdenv.lib.enableFeature monolithic "monolithic")
    (stdenv.lib.enableFeature daemon "amule-daemon")
    (stdenv.lib.enableFeature client "amule-gui")
    (stdenv.lib.enableFeature httpServer "webserver")
  ];

  postConfigure = ''
    sed -i "src/libs/ec/file_generator.pl"     \
        -es'|/usr/bin/perl|${perl}/bin/perl|g'
  '';

  # aMule will try to `dlopen' libupnp and libixml, so help it
  # find them.
  postInstall = lib.optionalString monolithic ''
    wrapProgram "$out/bin/amule" --prefix LD_LIBRARY_PATH ":" "${libupnp}/lib"
  '';

  meta = {
    homepage = http://amule.org/;
    description = "Peer-to-peer client for the eD2K and Kademlia networks";

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

    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.phreedom ];
  };
}
