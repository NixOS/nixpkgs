{ monolithic ? true # build monolithic amule
, enableDaemon ? false # build amule daemon
, httpServer ? false # build web interface for the daemon
, client ? false # build amule remote gui
, fetchFromGitHub, stdenv, lib, zlib, wxGTK, perl, cryptopp, libupnp, gettext, libpng
, autoreconfHook, pkg-config, makeWrapper, libX11 }:

stdenv.mkDerivation rec {
  pname = "amule";
  version = "unstable-20201006";

  src = fetchFromGitHub {
    owner = "amule-project";
    repo = "amule";
    rev = "6f8951527eda670c7266984ce476061bfe8867fc";
    sha256 = "12b44b6hz3mb7nsn6xhzvm726xs06xcim013i1appif4dr8njbx1";
  };

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

  nativeBuildInputs = [ autoreconfHook gettext makeWrapper pkg-config ];

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
    # Could not find crypto++ installation or sources.
    broken = true;
  };
}
