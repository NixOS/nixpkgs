{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NZDdSIXNQFSCoav+YN1VLFrHQSKZfoZDp2TWXtmQC6o=";
  };

  vendorHash = "sha256-oYagIEb/u/XCTbZkvynxcOtORhW75hReinrVAkdOApM=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.BazeliskVersion=${version}" ];

  meta = with lib; {
    description = "A user-friendly launcher for Bazel";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
