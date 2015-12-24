{stdenv, fetchzip, which, ocaml}:
let
  ocaml_version = (stdenv.lib.getVersion ocaml);
  version = "4.02+6";

in

assert stdenv.lib.versionAtLeast ocaml_version "4.02";

stdenv.mkDerivation {
  name = "camlp4-${version}";
  src = fetchzip {
    url = "https://github.com/ocaml/camlp4/archive/${version}.tar.gz";
    sha256 = "06yl4q0qazl7g25b0axd1gdkfd4qpqzs1gr5fkvmkrcbz113h1hj";
  };

  buildInputs = [ which ocaml ];

  dontAddPrefix = true;

  preConfigure = ''
    configureFlagsArray=(
      --bindir=$out/bin
      --libdir=$out/lib/ocaml/${ocaml_version}/site-lib
      --pkgdir=$out/lib/ocaml/${ocaml_version}/site-lib
    )
  '';

  postConfigure = ''
    substituteInPlace camlp4/META.in \
    --replace +camlp4 $out/lib/ocaml/${ocaml_version}/site-lib/camlp4
  '';


  makeFlags = "all";

  installTargets = "install install-META";

  meta = with stdenv.lib; {
    description = "A software system for writing extensible parsers for programming languages";
    homepage = https://github.com/ocaml/camlp4;
    platforms = ocaml.meta.platforms or [];
  };
}
