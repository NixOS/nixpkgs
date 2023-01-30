{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qWEEcIbTgYmGVnnTW+hM8e8nw5VLWN1TwzdUIZrxF3s=";
  };

  vendorSha256 = "sha256-dlt+i/pEP3RzW4JwndKTU7my2Nn7/2rLFlk8n1sFR60=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [krostar];
  };
}
