{ stdenv, fetchzip, ocaml }:

let version = "0.1.10"; in

stdenv.mkDerivation {
  name = "obuild-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-obuild/obuild/archive/obuild-v${version}.tar.gz";
    sha256 = "15arsgbhk1c39vd8qhpa3pag94m44bwvzggdvkibx6hnpkv8z9bn";
  };

  buildInputs = [ ocaml ];

  buildPhase = ''
    patchShebangs ./bootstrap
    ./bootstrap
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dist/build/obuild/obuild dist/build/obuild-from-oasis/obuild-from-oasis dist/build/obuild-simple/obuild-simple $out/bin/
  '';

  meta = {
    homepage = https://github.com/ocaml-obuild/obuild;
    platforms = ocaml.meta.platforms or [];
    description = "Simple package build system for OCaml";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ volth ];
  };
}
