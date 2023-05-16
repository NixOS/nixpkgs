<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation {
  pname = "ledit";
  version = "2.06";

  src = fetchFromGitHub {
    owner = "chetmurthy";
    repo = "ledit";
    rev = "3dbd668d9c69aab5ccd61f6b906c14122ae3271d";
    hash = "sha256-9+isvwOw5Iw5OToztqZ5PiQPj6Pxl2ZqAC7UMF+tCM4=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace /bin/rm rm --replace /usr/local/ $out/
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  strictDeps = true;

<<<<<<< HEAD
  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    camlp5
  ];

  buildInputs = with ocamlPackages; [
    camlp5
    camlp-streams
  ];


=======
  nativeBuildInputs = [
    ocaml
    camlp5
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "http://pauillac.inria.fr/~ddr/ledit/";
    description = "A line editor, allowing to use shell commands with control characters like in emacs";
    license = licenses.bsd3;
    maintainers = [ maintainers.delta ];
<<<<<<< HEAD
=======
    broken = lib.versionOlder ocaml.version "4.03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
