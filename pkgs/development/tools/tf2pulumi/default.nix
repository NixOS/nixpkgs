{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tf2pulumi";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "tf2pulumi";
    rev = "v${version}";
    sha256 = "199c4hd236mfz9c44rpzpbr3w3fjj8pbw656jd9k3v2igzw942c7";
  };

  vendorSha256 = "1cwyag67q0361szfjv1cyi51cg1bbmkpy34y33hn53aa55pkm1fw";

  buildFlagsArray = ''
    -ldflags=-s -w -X=github.com/pulumi/tf2pulumi/version.Version=${src.rev}
  '';

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert Terraform projects to Pulumi TypeScript programs";
    homepage = "https://www.pulumi.com/tf2pulumi/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
