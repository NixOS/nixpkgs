{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "open-policy-agent";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    rev = "v${version}";
    sha256 = "078ksgdl34yrr1w4l2p9r0zysxwzq7ml00mixhdr86rkmjii85zl";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  buildFlagsArray = [
    "-ldflags="
    "-X github.com/open-policy-agent/opa/version.Version=${version}"
  ];

  meta = with lib; {
    description = "General-purpose policy engine";
    longDescription = ''
      The Open Policy Agent (OPA, pronounced "oh-pa") is an open source, general-purpose policy engine that unifies
      policy enforcement across the stack. OPA provides a high-level declarative language that let’s you specify policy
      as code and simple APIs to offload policy decision-making from your software. You can use OPA to enforce policies
      in microservices, Kubernetes, CI/CD pipelines, API gateways, and more.
    '';
    homepage = "https://www.openpolicyagent.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ lewo ];
  };
}
