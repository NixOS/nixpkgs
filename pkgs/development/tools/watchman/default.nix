{ stdenv, lib, config, fetchFromGitHub, autoconf, automake, pcre
, libtool, pkgconfig, openssl
, confFile ? config.watchman.confFile or null
, withApple ? stdenv.isDarwin, CoreServices
}:

stdenv.mkDerivation rec {
  name = "watchman-${version}";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "v${version}";
    sha256 = "0fdaj5pmicm6j17d5q7px800m5rmam1a400x3hv1iiifnmhgnkal";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig libtool ];
  buildInputs = [ pcre openssl ]
    ++ lib.optionals withApple [ CoreServices ];

  configureFlags = [
    "--enable-lenient"
    "--enable-conffile=${if confFile == null then "no" else confFile}"
    "--with-pcre=yes"

    # For security considerations re: --disable-statedir, see:
    # https://github.com/facebook/watchman/issues/178
    "--disable-statedir"
  ];

  prePatch = ''
    patchShebangs .
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Watches files and takes action when they change";
    homepage    = https://facebook.github.io/watchman;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = with platforms; linux ++ darwin;
    license     = licenses.asl20;
  };
}
