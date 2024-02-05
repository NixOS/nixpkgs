{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "1.32.6";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-ftotZwRxcBErKzh1dZYqScTW12/tCOOHFJuruB5FOMU=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-RpwIPWzzAxXvDCf2CGnKo4NtsIe7QS4gVP1zeFgq+BQ=";
  proxyVendor = true;
  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/dolthub/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
