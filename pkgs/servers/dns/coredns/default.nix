{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-8IYJxb+HssS2xTboBRo3lz9czklt/Sn098ATlDaO7Gs=";
  };

  vendorSha256 = "sha256-Vxs+k4WF55xwjgdlW/1NM4NWnYqj2EOLOONflj+BoY4=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
