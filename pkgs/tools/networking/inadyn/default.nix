{ stdenv, fetchFromGitHub, gnutls33, autoreconfHook }:

let
  version = "1.99.13";
in
stdenv.mkDerivation {
  name = "inadyn-${version}";

  src = fetchFromGitHub {
    repo = "inadyn";
    owner = "troglobit";
    rev = version;
    sha256 = "19z8si66b2kwb7y29qpd8y45rhg5wrycwkdgjqqp98sg5yq8p7v0";
  };

  preConfigure = ''
    export makeFlags=prefix=$out
  '';

  buildInputs = [ gnutls33 autoreconfHook ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  meta = {
    homepage = http://inadyn.sourceforge.net/;
    description = "Free dynamic DNS client";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
