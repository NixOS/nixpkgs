{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-mPZvREBwSyy7dhVl2mJt58T09a0CYaMfJn7GEvfuupI=";
  };

  vendorSha256 = "sha256-DTw7SVZGl7QdlSpqWx11bjeNUwfb4VlwsGxqPVz6vhI=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
