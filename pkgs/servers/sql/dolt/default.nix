{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "1.42.13";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-K07cs9f7g9tDyPLChx21gYvFLYis2ZKfSlOsoz4YxFM=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-jaRZLLUk3ZeTZS1GDChJbpmRhavwn8iG7kF08KMB5KE=";
  proxyVendor = true;
  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
