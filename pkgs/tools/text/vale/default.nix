{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
<<<<<<< HEAD
  version = "2.28.3";
=======
  version = "2.26.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/vale" ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uRQGTVEueIe7tk0jd25V2MIBBxbWmXLYDu2lCofq/uY=";
  };

  vendorHash = "sha256-YUazrbTeioRV+L6Ku+oJRJzp16WCLPzlAH6F25TT6Dg=";
=======
    hash = "sha256-giGiA1W7mKOsP3yj8FhbXr0hL2YV7dRmkyUCkqsngWM=";
  };

  vendorHash = "sha256-KB1mRWDYejc38tUv316MiGfmq2riNnpEMIUpjgfSasU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mkdir -p $data/share/vale
    cp -r testdata/styles $data/share/vale
  '';

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
<<<<<<< HEAD
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    homepage = "https://vale.sh/";
    changelog = "https://github.com/errata-ai/vale/releases/tag/v${version}";
=======
    homepage = "https://vale.sh/";
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
