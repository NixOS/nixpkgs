{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "v2ray-core";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "v2fly";
    repo = "v2ray-core";
    rev = "v${version}";
    sha256 = "1w5mp6qi5i59w8ipg7nm6rivdbk8630fhgllkpiadsjdlb4nvc7k";
  };

  vendorSha256 = "1xl3wg7m7rpydi5j9cpwyha7h761nv3za6jcgnwhgazk0h1c5q26";

  subPackages = [ "main" ];

  postInstall = ''
    mv $out/bin/{main,v2ray}
  '';

  meta = {
    homepage = "https://www.v2fly.org/en_US/";
    description = "A platform for building proxies to bypass network restrictions";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ servalcatty nickcao ];
  };
}
