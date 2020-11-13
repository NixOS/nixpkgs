{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "open-policy-agent";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    rev = "v${version}";
    sha256 = "0fv2rq8a01hapcpgfqp71v113iyyzs5w1sam14h9clyr1vqrbcf2";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  buildFlagsArray = [
    "-ldflags="
    "-X github.com/open-policy-agent/opa/version.Version=${version}"
  ];

  meta = with lib; {
    description = "General-purpose policy engine";
    homepage = "https://www.openpolicyagent.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ lewo ];
  };
}
