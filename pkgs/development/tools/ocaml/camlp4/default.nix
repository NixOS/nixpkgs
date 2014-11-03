{stdenv, fetchurl, which, ocaml}:
let
  ocaml_version = (stdenv.lib.getVersion ocaml);
in
stdenv.mkDerivation {
  name = "camlp4-4.02.0+1";

  src =
    if ocaml_version == "4.02.0" then
      fetchurl {
        url = https://github.com/ocaml/camlp4/archive/4.02.0+1.tar.gz;
        sha256 = "0055f4jiz82rgn581xhq3mr4qgq2qgdxqppmp8i2x1xnsim4h9pn";
      }
    else
    if ocaml_version == "4.02.1" then
      fetchurl {
        url = https://github.com/ocaml/camlp4/archive/4.02.1+1.tar.gz;
        sha256 = "1lk2dyh9yq3xvviihkm4z4j2cqh6ix3blfqkp9bsfq1rb83jrv06";
      }
    else
    throw "no camlp4 expression for ${ocaml.name}";

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

  makePhase = "make all";

  installTargets = "install install-META";

  meta = with stdenv.lib; {
    description = "A software system for writing extensible parsers for programming languages";
    homepage = https://github.com/ocaml/camlp4;
    maintainers = with maintainers; [ emery ];
    platforms = ocaml.meta.platforms;
  };
}
