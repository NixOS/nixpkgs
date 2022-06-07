{ monolithic ? true # build monolithic amule
, enableDaemon ? false # build amule daemon
, httpServer ? false # build web interface for the daemon
, client ? false # build amule remote gui
, fetchFromGitHub
, stdenv
, lib
, cmake
, zlib
, wxGTK30-gtk3 # WxGTK 3.0 must be used because aMule does not yet work well with 3.1
, perl
, cryptopp
, libupnp
, boost # Not using boost leads to crashes with gtk3
, gettext
, libpng
, autoreconfHook
, pkg-config
, makeWrapper
, libX11
}:

# daemon and client are not build monolithic
assert monolithic || (!monolithic && (enableDaemon || client));

stdenv.mkDerivation rec {
  pname = "amule"
    + lib.optionalString enableDaemon "-daemon"
    + lib.optionalString client "-gui";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "amule-project";
    repo = "amule";
    rev = version;
    sha256 = "1nm4vxgmisn1b6l3drmz0q04x067j2i8lw5rnf0acaapwlp8qwvi";
  };

  nativeBuildInputs = [ cmake gettext makeWrapper pkg-config ];

  buildInputs = [
    zlib
    wxGTK30-gtk3
    perl
    cryptopp.dev
    libupnp
    boost
  ] ++ lib.optional httpServer libpng
  ++ lib.optional client libX11;

  cmakeFlags = [
    "-DBUILD_MONOLITHIC=${if monolithic then "ON" else "OFF"}"
    "-DBUILD_DAEMON=${if enableDaemon then "ON" else "OFF"}"
    "-DBUILD_REMOTEGUI=${if client then "ON" else "OFF"}"
    "-DBUILD_WEBSERVER=${if httpServer then "ON" else "OFF"}"
    # building only the daemon fails when these are not set... this is
    # due to mistakes in the Amule cmake code, but it does not cause
    # extra code to be built...
    "-Dwx_NEED_GUI=ON"
    "-Dwx_NEED_ADV=ON"
    "-Dwx_NEED_NET=ON"
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
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
