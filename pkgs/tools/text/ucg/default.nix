{ lib, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, pcre
, nixosTests
}:

let
  pname = "ucg";
  version = "20190225";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "gvansickle";
    repo = pname;
    rev = "c3a67632f1e3f332bfb102f0db167f34a2e42da7";
    sha256 = "sha256-/wU1PmI4ejlv7gZzZNasgROYXFiDiIxE9BFoCo6+G5Y=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ pcre ];

  meta = with lib; {
    homepage = "https://github.com/gvansickle/ucg/";
    description = "Grep-like tool for searching large bodies of source code";
    longDescription = ''
      UniversalCodeGrep (ucg) is an extremely fast grep-like tool specialized
      for searching large bodies of source code. It is intended to be largely
      command-line compatible with Ack, to some extent with ag, and where
      appropriate with grep. Search patterns are specified as PCRE regexes.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };

  passthru.tests = { inherit (nixosTests) ucg; };
}
