{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FQx5k6HuOf3gKa71LteNGhH2KILUQ+aeKmtQXRwTNYI=";
  };

  vendorSha256 = "sha256-VsP1YWvszux7qiRVLRF40NX3qoNOa9yrfRhQAaw7aKI=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
