{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F3paYKK+L5mBCQvlusKlSBS1X9fVSDHFw1Ujiyo5yrc=";
  };

  vendorHash = "sha256-V1GKZPLBjFhl0F0AvUC6MfAsrZsVToSZU3K2/hwOCVs=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.BazeliskVersion=${version}" ];

  meta = with lib; {
    description = "A user-friendly launcher for Bazel";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
