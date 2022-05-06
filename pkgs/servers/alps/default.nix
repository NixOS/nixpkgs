{ lib, buildGoModule, fetchFromSourcehut }:

buildGoModule rec {
  pname = "alps";
  version = "2022-03-01";

  src = fetchFromSourcehut {
    owner = "~migadu";
    repo = "alps";
    rev = "f4523b51af0787795973b403b978ff74737a47ef";
    hash = "sha256-un1RGIABFhHKeXPXtLnGayyoGzfo5PZc8VBSHA0PAaw=";
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
