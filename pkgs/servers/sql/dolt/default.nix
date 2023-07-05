{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-oMfph6hNo3TD4LNAPH1LJT6ectmi7fF+J2uASrIfL+0=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-SKIp3xdnVN0l/kRf4XXyEV3rOfPXsBEqFDn6uvHe5/Y=";
  proxyVendor = true;
  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/dolthub/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
