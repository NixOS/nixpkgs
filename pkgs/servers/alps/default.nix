{ lib, buildGoModule, fetchFromSourcehut }:

buildGoModule rec {
  pname = "alps";
  version = "2021-09-29";

  src = fetchFromSourcehut {
    owner = "~migadu";
    repo = "alps";
    rev = "d4c35f3c3157bece8e50fd95f2ee1081be30d7ae";
    sha256 = "sha256-xKfRLdfeD7lWdmC0iiq4dOIv2SmzbKH7HcAISCJgdug=";
  };

  vendorSha256 = "sha256-Vg0k+YSMg6Ree/jkVV2VQ8RbSbQFUhmUN2MeTBxPeLo=";

  proxyVendor = true;

  meta = with lib; {
    description = "A simple and extensible webmail.";
    homepage = "https://git.sr.ht/~migadu/alps";
    license = licenses.mit;
    maintainers = with maintainers; [ gordias ];
  };
}
