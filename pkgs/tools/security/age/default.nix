{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "age";
  version = "1.0.0-beta6";
  vendorSha256 = "sha256-FTByNpLkWWHAWe5wVDRBGtKap/5+XGHeBMQAIdlPCkA=";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "sha256-1LCcCEf2/R0am0jpA8yKl44+AoUFkbepxp9V6/nZkBQ=";
  };

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
