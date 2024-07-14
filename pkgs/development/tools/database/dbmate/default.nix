{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-LNA66Uz/cgwx3Bq2FXpW7+3vh2VXWPyyrlAcRK5MlGU=";
  };

  vendorHash = "sha256-ypGPVJ0cfHMGDqOV2xt5MQs9X3YtCW8+sChQ9SPOZAY=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
