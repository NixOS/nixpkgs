{stdenv, fetchurl, makeWrapper, ocaml, ncurses}:
let
  pname = "omake";
  version = "0.9.8.6-0.rc1";
  webpage = "http://omake.metaprl.org";
in
stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/downloads/${pname}-${version}.tar.gz";
    sha256 = "1sas02pbj56m7wi5vf3vqrrpr4ynxymw2a8ybvfj2dkjf7q9ii13";
  };
  patchFlags = "-p0";
  patches = [ ./warn.patch ];

  buildInputs = [ ocaml makeWrapper ncurses ];

  phases = "unpackPhase patchPhase buildPhase";
  buildPhase = ''
    make bootstrap
    make PREFIX=$out all
    make PREFIX=$out install
  '';
#  prefixKey = "-prefix ";
#
#  configureFlags = if transitional then "--transitional" else "--strict";
#
#  buildFlags = "world.opt";		

  meta = {
    description = "Omake build system";
    homepage = "${webpage}";
    license = "GPL";
    platforms = ocaml.meta.platforms;
  };
}
