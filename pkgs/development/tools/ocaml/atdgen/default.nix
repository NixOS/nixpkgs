{ stdenv, fetchurl, which, ocaml, findlib, atd, biniou, yojson }:

let version = "1.4.1"; in
stdenv.mkDerivation {
  name = "atdgen-${version}";

  src = fetchurl {
    url = "http://mjambon.com/releases/atdgen/atdgen-${version}.tar.gz";
    sha256 = "0r580xnniz8zm1lv505nfkj7knpplnmskw72i2m40xsnaf4q2f1g";
  };

  buildInputs = [ which ocaml findlib atd biniou yojson ];

  createFindlibDestdir = true;

  preBuild = "export PREFIX=$out";
  preInstall = "mkdir -p $out/bin";

  meta = with stdenv.lib;
    { description = "Program that takes as input type definitions in the ATD syntax and produces OCaml code suitable for data serialization and deserialization";
      maintainers = with maintainers; [ emery ];
    };
}
