{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gengetopt
, glib, libconfig, libnice, jansson, boringssl, zlib, srtp, libuv
, libmicrohttpd, curl, libwebsockets, sofia_sip, libogg, libopus
, usrsctp, ffmpeg
}:

let
  libwebsockets_janus = libwebsockets.overrideAttrs (_: {
    configureFlags = [
      "-DLWS_MAX_SMP=1"
      "-DLWS_WITHOUT_EXTENSIONS=0"
    ];
  });
in

stdenv.mkDerivation rec {
  pname = "janus-gateway";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "meetecho";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2UlIpxixTl16VG6lgcfk+9LXSWn0jV1IfIkCeV/SO5w=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config gengetopt ];

  buildInputs = [
    glib libconfig libnice jansson boringssl zlib srtp libuv libmicrohttpd
    curl libwebsockets_janus sofia_sip libogg libopus usrsctp ffmpeg
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-boringssl=${lib.getDev boringssl}"
    "--enable-libsrtp2"
    "--enable-turn-rest-api"
    "--enable-json-logger"
    "--enable-gelf-event-handler"
    "--enable-post-processing"
  ];

  makeFlagsArray = [
    "BORINGSSL_LIBS=-L${lib.getLib boringssl}/lib"
  ];

  outputs = [ "out" "dev" "doc" "man" ];

  postInstall = ''
    moveToOutput share/janus "$doc"
    moveToOutput etc "$doc"
  '';

  meta = with lib; {
    description = "General purpose WebRTC server";
    homepage = "https://janus.conf.meetecho.com/";
    changelog = "https://github.com/meetecho/janus-gateway/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
