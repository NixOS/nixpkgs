{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libevent, file, qrencode, miniupnpc }:

stdenv.mkDerivation rec {
  name = "pshs-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mgorny";
    repo = "pshs";
    rev = "v${version}";
    sha256 = "1ffdyv5qiqdg3jq8y91fsml046g88d7fyy2k81yii11jw3yx2js0";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libevent file qrencode miniupnpc ];

  # SSL requires libevent at 2.1 with ssl support
  configureFlags = "--disable-ssl";

  meta = {
    description = "Pretty small HTTP server - a command-line tool to share files";
    homepage = https://github.com/mgorny/pshs;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
    platforms = stdenv.lib.platforms.linux;
  };
}
