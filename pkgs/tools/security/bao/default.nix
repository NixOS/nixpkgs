{ lib
<<<<<<< HEAD
, rustPlatform
, fetchCrate
=======
, fetchCrate
, fetchpatch
, rustPlatform
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "bao";
<<<<<<< HEAD
  version = "0.12.1";
=======
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    inherit version;
    pname = "${pname}_bin";
<<<<<<< HEAD
    sha256 = "sha256-+MjfqIg/aKPWhzxbPJ0dnS4egCj50Ib7ob3zXUSBXRg=";
  };

  cargoHash = "sha256-SNsRN5XgchZq6/BZnMeahIqnkP4Jq6bZxbE5cDVpsQA=";
=======
    sha256 = "SkplBzor7Fv2+6K8wcTtZwjR66RfLPA/YNNUUHniWpM=";
  };

  cargoSha256 = "yr4HvtOWnU2dFTBgSsbVcuDELe1o1SEtZ7rN/ctKAdI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "An implementation of BLAKE3 verified streaming";
    homepage = "https://github.com/oconnor663/bao";
    maintainers = with lib.maintainers; [ amarshall ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
