{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tf2pulumi";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "tf2pulumi";
    rev = "v${version}";
    sha256 = "0dd44z78iqh9asa2jh9am2z5fbmn0gch7lfij3h9ngia25h5fpsb";
  };

  vendorSha256 = "17rn0pshfm4mpqxk3klni4qrw4rvz8vi42s5kidblpf576n0vj62";

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
