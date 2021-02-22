{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.6.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "mozilla";
    repo = pname;
    sha256 = "0xl53rs8jzq5yz4wi0vzsr6ajsaf2x2n1h3x7krk02a9839y6f18";
  };

  vendorSha256 = "1cpm06dyc6lb3a9apfggyi16alb2yijvyan1gbrl8r9fwlqvdpjk";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
