{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "cotton";
  version = "unstable-2022-10-04";

  src = fetchFromGitHub {
    owner = "danielhuang";
    repo = pname;
    rev = "30f3aa7ec6792f3e2dbafc9f4b009b1a6eadc755";
    sha256 = "sha256-jq5aW6dViHTxh2btP5smtcyUSZ1EoMrQVN7K8zs1jJM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "node-semver-2.0.1-alpha.0" = "sha256-TIMynpmRIrnft6kZjX3nJC/BafgudH/d01dpraM5YmU=";
      "tokio-tar-0.3.0" = "sha256-mD6bls4rGsJhu/W56C5VYgK4mzcSJ2DPOaPAbRLStT8=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A package manager for JavaScript projects";
    homepage = "https://github.com/danielhuang/cotton";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
