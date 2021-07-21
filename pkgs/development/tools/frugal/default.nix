{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frugal";
  version = "3.14.6";

  src = fetchFromGitHub {
    owner = "Workiva";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MtQz/9+e2l4FQ1E299KtRzFpX67FynHdsvcMA4CqKUo=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-Y7lh+U4FKiht2PgACWSXwGTx+y8aJi22KEhqxHPooCw=";

  meta = with lib; {
    description = "Thrift improved";
    homepage = "https://github.com/Workiva/frugal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ diogox ];
  };
}
