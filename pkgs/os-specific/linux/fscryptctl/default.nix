{ stdenv, fetchFromGitHub }:

# Don't use this for anything important yet!

stdenv.mkDerivation rec {
  name = "fscryptctl-unstable-${version}";
  version = "2017-09-12";

  goPackagePath = "github.com/google/fscrypt";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscryptctl";
    rev = "f037dcf4354ce8f25d0f371b58dfe7a7ac27576f";
    sha256 = "1dw1y6jbm2ibn7npvpw6cl28rcz0jz4as2yl6walz7ppmqbj9scf";
  };

  patches = [ ./install.patch ];

  makeFlags = [ "DESTDIR=$(out)/bin" ];

  meta = with stdenv.lib; {
    description = ''
      A low-level tool that handles raw keys and manages policies for Linux
      filesystem encryption
    '';
    inherit (src.meta) homepage;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
