{ stdenv, fetchFromGitHub, cmake, asciidoc }:

stdenv.mkDerivation rec {
  pname = "kimg";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kimg";
    rev = version;
    sha256 = "040782k3rh2a5mhbfgr9gnbfis0wgxvi27vhfn7l35vrr12sw1l3";
  };

  nativeBuildInputs = [ cmake asciidoc ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "Converts image formats supported by stb_image to the KnightOS image format";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.all;
  };
}
