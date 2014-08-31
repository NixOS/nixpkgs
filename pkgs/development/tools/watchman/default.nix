{ stdenv, lib, config, fetchFromGitHub, autoconf, automake, pcre
, confFile ? config.watchman.confFile or null
}:

stdenv.mkDerivation rec {
  name = "watchman-${version}";

  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "v${version}";
    sha256 = "196d71ci7ki4p6xx49w55cqd0bqrx19nf79na3a91mrfa6f22sp6";
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
