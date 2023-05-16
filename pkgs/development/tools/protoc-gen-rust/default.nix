{ fetchCrate
, lib
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "protoc-gen-rust";
<<<<<<< HEAD
  version = "3.2.0";
=======
  version = "3.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    inherit version;
    pname = "protobuf-codegen";
<<<<<<< HEAD
    sha256 = "sha256-9Rf7GI/qxoqlISD169TJwUVAdJn8TpxTXDNxiQra2UY=";
  };

  cargoSha256 = "sha256-i1ZIEbU6tw7xA1w+ffD/h1HIkOwVep9wQJys9Bydvv0=";
=======
    sha256 = "sha256-DaydUuENqmN812BgQmpewRPhkq9lT6+g+VPuytLc25Y=";
  };

  cargoSha256 = "sha256-kzc2Wd+Y3mNmOHxRj5R1LIbvXz5NyGcRnz2e0jdfdPg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cargoBuildFlags = ["--bin" pname];

  nativeBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Protobuf plugin for generating Rust code";
    homepage = "https://github.com/stepancheg/rust-protobuf";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
