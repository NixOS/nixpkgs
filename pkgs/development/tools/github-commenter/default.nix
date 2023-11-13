{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "github-commenter";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = version;
    hash = "sha256-pCcTdj2ZgGIpa6784xkBX29LVu1o5ORqqk9j9wR/V8k=";
  };

  vendorHash = "sha256-etR//FfHRzCL6WEZSqeaKYu3eLjxA0x5mZJRe1yvycQ=";

  meta = with lib; {
    description = "Command line utility for creating GitHub comments on Commits, Pull Request Reviews or Issues";
    license = licenses.asl20;
    homepage = "https://github.com/cloudposse/github-commenter";
    maintainers = [ maintainers.mmahut ];
  };
}
