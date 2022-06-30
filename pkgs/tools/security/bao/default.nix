{ lib
, fetchCrate
, fetchpatch
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "bao";
  version = "0.12.0";

  src = fetchCrate {
    inherit version;
    pname = "${pname}_bin";
    sha256 = "SkplBzor7Fv2+6K8wcTtZwjR66RfLPA/YNNUUHniWpM=";
  };

  cargoSha256 = "yr4HvtOWnU2dFTBgSsbVcuDELe1o1SEtZ7rN/ctKAdI=";

  meta = {
    description = "An implementation of BLAKE3 verified streaming";
    homepage = "https://github.com/oconnor663/bao";
    maintainers = with lib.maintainers; [ amarshall ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
