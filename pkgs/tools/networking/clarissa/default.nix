{ lib, stdenv
, fetchFromGitLab
, libpcap, perl
, asciidoctor
}:

stdenv.mkDerivation rec {

  pname = "clarissa";
  version = "1.0-80-g00c2581";

  outputs = [ "out" "man" ];
  separateDebugInfo = true;

  src = fetchFromGitLab {
    owner = "evils";
    repo = "clarissa";
    rev = "00c258184642f62d7ce151bcf7ce5e13e72ce681";
    hash = "sha256-YQzsZ9rooCTUaGG7GVAmN0aTmNHzPHARHWhwXSgWUHU=";
  };

  nativeBuildInputs = [ asciidoctor ];
  buildInputs = [ libpcap ];

  installTargets = "install-clarissa";

  checkInputs = [ perl ];
  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  checkTarget = "test";
  doCheck = true;

  dontBuild = true;

  meta = with lib; {
    description = "Near-real-time network census daemon";
    longDescription = ''
      Clarissa is a daemon which keeps track of connected MAC addresses on a network.
      It can report these with sub-second resolution and can monitor passively.
    '';
    homepage = "https://gitlab.com/evils/clarissa";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.evils ];
  };
}
