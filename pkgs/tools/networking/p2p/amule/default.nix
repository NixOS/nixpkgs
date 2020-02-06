{ monolithic ? true # build monolithic amule
, enableDaemon ? false # build amule daemon
, httpServer ? false # build web interface for the daemon
, client ? false # build amule remote gui
, fetchFromGitHub, fetchpatch, stdenv, lib, zlib, wxGTK, perl, cryptopp, libupnp, gettext, libpng ? null
, autoreconfHook, pkgconfig, makeWrapper, libX11 ? null }:

assert httpServer -> libpng != null;
assert client -> libX11 != null;

stdenv.mkDerivation rec {
  pname = "amule";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "amule-project";
    repo = "amule";
    rev = version;
    sha256 = "010wxm6g9f92x6fympj501zbnjka32rzbx0sk3a2y4zpih5d2nsn";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/amule-project/amule/pull/135.patch";
      sha256 = "1n24r1j28083b8ipbnh1nf6i4j6vx59pdkfl1c0g6bb4psx9wvvi";
      name = "libupnp_18.patch";
    })
    (fetchpatch {
      name = "amule-cryptopp_6.patch";
      url = "https://github.com/amule-project/amule/commit/27c13f3e622b8a3eaaa05bb62b0149604bdcc9e8.patch";
      sha256 = "0kq095gi3xl665wr864zlhp5f3blk75pr725yany8ilzcwrzdrnm";
    })
  ];

  postPatch = ''
    substituteInPlace src/libs/ec/file_generator.pl \
      --replace /usr/bin/perl ${perl}/bin/perl

    # autotools expects these to be in the root
    cp docs/{AUTHORS,README} .
    cp docs/Changelog ./ChangeLog
    cp docs/Changelog ./NEWS
  '';

  preAutoreconf = ''
    pushd src/pixmaps/flags_xpm >/dev/null
    ./makeflags.sh
    popd >/dev/null
  '';

  nativeBuildInputs = [ autoreconfHook gettext makeWrapper pkgconfig ];

  buildInputs = [
    zlib wxGTK perl cryptopp libupnp
  ] ++ lib.optional httpServer libpng
    ++ lib.optional client libX11;

  enableParallelBuilding = true;

  configureFlags = [
    "--with-crypto-prefix=${cryptopp}"
    "--disable-debug"
    "--enable-optimize"
    (lib.enableFeature monolithic   "monolithic")
    (lib.enableFeature enableDaemon "amule-daemon")
    (lib.enableFeature client       "amule-gui")
    (lib.enableFeature httpServer   "webserver")
  ];

  # aMule will try to `dlopen' libupnp and libixml, so help it
  # find them.
  postInstall = lib.optionalString monolithic ''
    wrapProgram $out/bin/amule \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libupnp ]}
  '';

  meta = with lib; {
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

    homepage = "https://github.com/amule-project/amule";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ phreedom ];
    platforms = platforms.unix;
  };
}
