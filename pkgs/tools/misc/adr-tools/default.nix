{ stdenv, fetchFromGitHub, getopt, bashInteractive }:

stdenv.mkDerivation rec {
  name = "adr-tools-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "npryce";
    repo = "adr-tools";
    rev = "${version}";
    sha256 = "1igssl6853wagi5050157bbmr9j12703fqfm8cd7gscqwjghnk14";
  };

  postPatch = ''
    substituteInPlace Makefile --replace '/bin:/usr/bin' '$(PATH)'
  '';

  propagatedBuildInputs = [ getopt bashInteractive ];

  buildPhase = ''
    patchShebangs src/
  '';

  doCheck = true;

  checkPhase = ''
    make check
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp src/* $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/npryce/adr-tools;
    description = "Command-line tools for working with Architecture Decision Records";
    license = licenses.gpl3;
    maintainers = [ maintainers.aepsil0n ];
    platforms = platforms.linux;
  };
}
