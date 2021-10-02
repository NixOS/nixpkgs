{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mkcert";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q0069ripnpb027krc4yk47552xl5rp0ymxf1j2mln9wdmfq65ba";
  };

  vendorSha256 = "133vlx825g4zay88ppylsz93q4gnd9ari12x1h57qvk45rwxqx95";

  doCheck = false;

  ldflags = [
    "-s" "-w" "-X main.Version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FiloSottile/mkcert";
    description = "A simple tool for making locally-trusted development certificates";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
