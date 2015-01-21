{ stdenv, lib, config, fetchFromGitHub, autoconf, automake, pcre
, confFile ? config.watchman.confFile or null
}:

stdenv.mkDerivation rec {
  name = "watchman-${version}";

  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "v${version}";
    sha256 = "0sf0cp9p7savlgmzqj5m9fkpfa5a15pv98rkilxnbmx9wrjvypwk";
  };

  buildInputs = [ autoconf automake pcre ];

  configureFlags = [
      "--enable-lenient"
      "--enable-conffile=${if confFile == null then "no" else confFile}"
      "--with-pcre=yes"
  ];

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
