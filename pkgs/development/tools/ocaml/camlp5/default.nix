{ stdenv, fetchzip, ocaml, legacy ? false }:

let params =
  if legacy then {
    minor-version = "06";
    sha256 = "02zg6qjkzx58zmp79364s5jyqhh56nclcz1jzhh53hk37g9f96qf";
  } else {
    minor-version = "07";
    sha256 = "1c8v45553ccbqha2ypfranqlgw06rr5wjr2hlnrx5bf9jfq0h0dn";
  };
  metafile = ./META;
  opt = stdenv.lib.optionalString legacy;
in

stdenv.mkDerivation {

  name = "camlp5-7.${params.minor-version}";

  src = fetchzip {
    url = "https://github.com/camlp5/camlp5/archive/rel7${params.minor-version}.tar.gz";
    inherit (params) sha256;
  };

  buildInputs = [ ocaml ];

  postPatch = opt ''
    for p in compile/compile.sh config/Makefile.tpl test/Makefile test/check_ocaml_versions.sh
    do
      substituteInPlace $p --replace '/bin/rm' rm
    done
  '';

  prefixKey = "-prefix ";

  preConfigure = "configureFlagsArray=(--strict" +
                  " --libdir $out/lib/ocaml/${ocaml.version}/site-lib)";

  buildFlags = "world.opt";

  postInstall = opt "cp ${metafile} $out/lib/ocaml/${ocaml.version}/site-lib/camlp5/META";

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = https://camlp5.github.io/;
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      z77z vbgl
    ];
  };
}
