{ stdenv, lib, config, fetchFromGitHub, autoconf, automake, pcre
, confFile ? config.watchman.confFile or null
}:

stdenv.mkDerivation rec {
  name = "watchman-${version}";

  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "watchman";
    rev = "v${version}";
    sha256 = "01ak2gsmc76baswpivzz00g22r547mpp8l7xfziwl5804nzszrcg";
  };

  buildInputs = [ autoconf automake pcre ];

  configureFlags = [
      "--enable-lenient"
      "--enable-conffile=${if confFile == null then "no" else confFile}"
      "--with-pcre=yes"
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
