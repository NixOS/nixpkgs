{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "1.42.7";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-IBsIpv/zTVYC9HKeA8sH0CDeqvAwZMwEi/Obdv4OI90=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-cjECZwuhdgp0LxXxZa7KJNvp3HTmIe7j8NH4wj/8WVA=";
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
