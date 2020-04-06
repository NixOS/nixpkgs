{ stdenv, fetchFromGitHub }:

# Don't use this for anything important yet!

stdenv.mkDerivation rec {
  pname = "fscryptctl-unstable";
  version = "2017-10-23";

  goPackagePath = "github.com/google/fscrypt";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscryptctl";
    rev = "142326810eb19d6794793db6d24d0775a15aa8e5";
    sha256 = "1853hlpklisbqnkb7a921dsf0vp2nr2im26zpmrs592cnpsvk3hb";
  };

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
