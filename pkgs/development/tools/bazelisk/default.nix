{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ijw0JVU9jUhpIJQjcjgzAVPJDxD7WSZYiLV0OvOyS5g=";
  };

  vendorHash = "sha256-Hg8rMknanHQOgVLJ58QM9JOgrUYMqL7WvaHuiv9xVYw=";

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
