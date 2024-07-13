{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UNrfLuSadkP3GBlFMg2V3mK/GSNlyvIxeHnkTuPjfy4=";
  };

  vendorHash = "sha256-hjV7Pc3DFExSCsA0jKVxb1GxoXQ7LRFGuot3V0IHG58=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.BazeliskVersion=${version}" ];

  meta = with lib; {
    description = "User-friendly launcher for Bazel";
    mainProgram = "bazelisk";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
