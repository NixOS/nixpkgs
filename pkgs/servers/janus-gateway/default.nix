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
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "meetecho";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1WQo1v5TJPPJjC2lc8k9aWmtRUFITYEuwSfsPzh5320=";
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
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
