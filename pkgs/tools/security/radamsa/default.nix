{ lib, stdenv, fetchurl, fetchFromGitLab, bash }:

let
  # Fetch explicitly, otherwise build will try to do so
  owl = fetchurl {
    name = "ol.c.gz";
    url = "https://gitlab.com/owl-lisp/owl/uploads/0d0730b500976348d1e66b4a1756cdc3/ol-0.1.19.c.gz";
    sha256 = "0kdmzf60nbpvdn8j3l51i9lhcwfi4aw1zj4lhbp4adyg8n8pp4c6";
  };
in
stdenv.mkDerivation rec {
  pname = "radamsa";
  version = "0.6";

  src = fetchFromGitLab {
    owner = "akihe";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mi1mwvfnlpblrbmp0rcyf5p74m771z6nrbsly6cajyn4mlpmbaq";
  };

  patchPhase = ''
    substituteInPlace ./tests/bd.sh  \
      --replace "/bin/echo" echo

    ln -s ${owl} ol.c.gz

    patchShebangs tests
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" "BINDIR=" ];

  nativeCheckInputs = [ bash ];
  doCheck = true;

  meta = {
    description = "A general purpose fuzzer";
    longDescription = "Radamsa is a general purpose data fuzzer. It reads data from given sample files, or standard input if none are given, and outputs modified data. It is usually used to generate malformed data for testing programs.";
    homepage =  "https://gitlab.com/akihe/radamsa";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
