{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "0.27.4.2";

  src = fetchFromGitHub {
    owner = "liquidata-inc";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-nEIYt9yPDxPbJ/IHH8eQpVSNtC5pYiagCC5TliqX11M=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" "cmd/git-dolt" "cmd/git-dolt-smudge" ];
  vendorSha256 = "sha256-XbKaPbPIgUxqJB8kgd3fJIESO9XvNREExdp06Th2bu0=";

  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/liquidata-inc/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
