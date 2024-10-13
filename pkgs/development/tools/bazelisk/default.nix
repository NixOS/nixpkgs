{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KD8lh3N9GFlht+HtcuE3i20noVha0lT21a5pSS3zbTw=";
  };

  vendorHash = "sha256-zoiQ69y0EicH9Jq2XYn+fttKHZY64GD4m/Edk+kle9M=";

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
