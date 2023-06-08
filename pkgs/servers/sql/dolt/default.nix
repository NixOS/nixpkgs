{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-4WnHJzHxd3wK1kEN2fvnp6PPnTnL28TTnOD0th2UK1U=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorSha256 = "sha256-hzhAuM6xPKl0KTlf02hAs7+jKX93JWe6aLfBwHWV8Eg=";
  proxyVendor = true;
  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    homepage = "https://github.com/dolthub/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
