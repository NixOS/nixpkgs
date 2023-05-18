{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nsq";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "nsqio";
    repo = "nsq";
    rev = "v${version}";
    sha256 = "0ajqjwfn06zsmz21z9mkl4cblarypaf20228pqcd1293zl6y3ry8";
  };

  vendorSha256 = "11sx96zshaciqrm8rqmhz1sf6nd4lczqwiha031xyyifvmpp2hsa";

  excludedPackages = [ "bench" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://nsq.io/";
    description = "A realtime distributed messaging platform";
    changelog = "https://github.com/nsqio/nsq/raw/v${version}/ChangeLog.md";
    license = licenses.mit;
  };
}
