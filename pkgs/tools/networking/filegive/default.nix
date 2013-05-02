{ stdenv, fetchurl, go }:

assert stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64 || stdenv.isArm);

stdenv.mkDerivation rec {
  name = "filegive-0.3";

  src = fetchurl {
    url = "http://viric.name/cgi-bin/filegive/tarball/filegive-0.3.tar.gz?uuid=v0.3";
    name = "${name}.tar.gz";
    sha256 = "1xiz47q6f579nb36p973bb3wjszn515v0sjh76pif1cihijdsb5y";
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
