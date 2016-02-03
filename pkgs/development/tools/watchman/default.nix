{ stdenv, lib, config, fetchFromGitHub, autoconf, automake, pcre
, confFile ? config.watchman.confFile or null
}:

stdenv.mkDerivation rec {
  name = "watchman-${version}";

  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "v${version}";
    sha256 = "0dcaklw4d42z8hndy9zsdqqv1q8r18wnwldgdgjvp5c9vijvgyrd";
  };

  buildInputs = [ autoconf automake pcre ];

  configureFlags = [
      "--enable-lenient"
      "--enable-conffile=${if confFile == null then "no" else confFile}"
      "--with-pcre=yes"

      # For security considerations re: --disable-statedir, see:
      # https://github.com/facebook/watchman/issues/178
      "--disable-statedir"
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
