{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "bao";
  version = "0.12.1";

  src = fetchCrate {
    inherit version;
    pname = "${pname}_bin";
    hash = "sha256-+MjfqIg/aKPWhzxbPJ0dnS4egCj50Ib7ob3zXUSBXRg=";
  };

  cargoHash = "sha256-SNsRN5XgchZq6/BZnMeahIqnkP4Jq6bZxbE5cDVpsQA=";

  meta = {
    description = "Implementation of BLAKE3 verified streaming";
    homepage = "https://github.com/oconnor663/bao";
    maintainers = with lib.maintainers; [ amarshall ];
    license = with lib.licenses; [
      cc0
      asl20
    ];
    mainProgram = "bao";
  };
}
