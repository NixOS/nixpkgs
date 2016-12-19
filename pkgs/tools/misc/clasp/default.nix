{ stdenv, fetchurl }:

let
  version = "3.1.4";
in

stdenv.mkDerivation {
  name = "clasp-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/potassco/clasp/${version}/clasp-${version}-source.tar.gz";
    sha256 = "1zkjqc4gp4n9p2kf3k3z8x82g42any4p3shhhivny89z1jlxi9zn";
  };

  preConfigure = "patchShebangs ./configure.sh";
  configureScript = "./configure.sh";

  preBuild = "cd build/release";

  installPhase = ''
    mkdir -p $out/bin
    cp bin/clasp $out/bin/clasp
  '';

  meta = with stdenv.lib; {
    description = "Answer set solver for (extended) normal and disjunctive logic programs";
    homepage = http://potassco.sourceforge.net/;
    platforms = platforms.all;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl2Plus;
  };
}
