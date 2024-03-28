{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-codeartifact-proxy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sktan";
    repo = "aws-codeartifact-proxy";
    rev = "v${version}";
    hash = "sha256-mHXqwH6C6jUighkeRUu4H30z0o+Y0Zh7aE6foGZ2gKY=";
  } + "/src";

  vendorSha256 = "3MO+mRCstXw0FfySiyMSs1vaao7kUYIyJB2gAp1IE48=";

  meta = with lib; {
    description =
      "An AWS CodeArtifact proxy to allow unauthenticated read access";
    homepage = "https://github.com/sktan/aws-codeartifact-proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ lafrenierejm ];
  };
}
