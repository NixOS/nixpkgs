{lib, stdenv, fetchurl, makeWrapper, ocaml, ncurses}:
let
  pname = "omake";
  version = "0.9.8.6-0.rc1";
  webpage = "http://omake.metaprl.org";
in

if lib.versionAtLeast ocaml.version "4.06"
then throw "${pname}-${version} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://src.fedoraproject.org/repo/pkgs/ocaml-omake/${pname}-${version}.tar.gz/fe39a476ef4e33b7ba2ca77a6bcaded2/${pname}-${version}.tar.gz";
    sha256 = "1sas02pbj56m7wi5vf3vqrrpr4ynxymw2a8ybvfj2dkjf7q9ii13";
  };
  patchFlags = [ "-p0" ];
  patches = [ ./warn.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ocaml ncurses ];

  dontInstall = true;
  buildPhase = ''
    make bootstrap
    make PREFIX=$out all
    make PREFIX=$out install
  '';
#  prefixKey = "-prefix ";
#
#  configureFlags = if transitional then "--transitional" else "--strict";
#
#  buildFlags = [ "world.opt" ];

  meta = {
    description = "Omake build system";
    homepage = webpage;
    license = "GPL";
    platforms = ocaml.meta.platforms or [];
  };
}
