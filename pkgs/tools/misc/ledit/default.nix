{ lib, stdenv, fetchzip, ocaml, camlp5}:

stdenv.mkDerivation {
  pname = "ledit";
  version = "2.04";

  src = fetchzip {
    url = "http://pauillac.inria.fr/~ddr/ledit/distrib/src/ledit-2.04.tgz";
    sha512 = "16vlv6rcsddwrvsqqiwxdfv5rxvblhrx0k84g7pjibi0an241yx8aqf8cj4f4sgl5xfs3frqrdf12zqwjf2h4jvk8jyhyar8n0nj3g0";
  };

  preBuild = ''
    mkdir -p $out/bin
    substituteInPlace Makefile --replace /bin/rm rm --replace BINDIR=/usr/local/bin BINDIR=$out/bin
  '';

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    camlp5
  ];

  meta = with lib; {
    homepage = "http://pauillac.inria.fr/~ddr/ledit/";
    description = "A line editor, allowing to use shell commands with control characters like in emacs";
    license = licenses.bsd3;
    maintainers = [ maintainers.delta ];
    broken = lib.versionOlder ocaml.version "4.03";
  };
}
