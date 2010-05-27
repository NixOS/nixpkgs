{stdenv, fetchurl, makeWrapper, ocaml, ncurses}:
let
  pname = "omake";
  version = "0.9.8.5-3";
  webpage = "http://omake.metaprl.org";
in
stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/downloads/${pname}-${version}.tar.gz";
    sha256 = "1bfxbsimfivq0ar2g5fkzvr5ql97n5dg562pfyd29y4zyh4mwrsv";
  };
  patchFlags = "-p0";
  patches = [ ./omake-build-0.9.8.5.diff ./omake-lm_printf-gcc44.diff ];

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
  };
}
