{stdenv, fetchurl, which, ocaml}:
let
  ocaml_version = (stdenv.lib.getVersion ocaml);
in

assert stdenv.lib.versionAtLeast ocaml_version "4.02";

stdenv.mkDerivation {
  name = "camlp4-4.02.0+1";
  src = fetchurl {
    url = https://github.com/ocaml/camlp4/archive/4.02.0+1.tar.gz;
    sha256 = "0055f4jiz82rgn581xhq3mr4qgq2qgdxqppmp8i2x1xnsim4h9pn";
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
    substituteInPlace camlp4/config/Camlp4_config.ml \
    --replace \
      "Filename.concat ocaml_standard_library" \
      "Filename.concat \"$out/lib/ocaml/${ocaml_version}/site-lib\""
  '';


  makeFlags = "all";

  installTargets = "install install-META";

  meta = with stdenv.lib; {
    description = "A software system for writing extensible parsers for programming languages";
    homepage = https://github.com/ocaml/camlp4;
    platforms = ocaml.meta.platforms;
  };
}
