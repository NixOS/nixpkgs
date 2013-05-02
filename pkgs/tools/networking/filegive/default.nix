{ stdenv, fetchurl, go }:

assert stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64 || stdenv.isArm);

stdenv.mkDerivation rec {
  name = "filegive-0.3.1";

  src = fetchurl {
    url = "http://viric.name/cgi-bin/filegive/tarball/filegive-0.3.1.tar.gz?uuid=v0.3.1";
    name = "${name}.tar.gz";
    sha256 = "14hsy7bkmhq03f2yf619kz8p11v8ndd59sdibck556z8dld7b6ya";
  };

  buildInputs = [ go ];

  buildPhase = ''
    ${stdenv.lib.optionalString (stdenv.system == "armv5tel-linux") "export GOARM=5"}
    go build -o filegive
  '';

  installPhase = ''
    ensureDir $out/bin
    cp filegive $out/bin
  '';

  meta = {
    homepage = http://viric.name/cgi-bin/filegive;
    description = "Easy p2p file sending program";
    license = "BSD";
  };
}
