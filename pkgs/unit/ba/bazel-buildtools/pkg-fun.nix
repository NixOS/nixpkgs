{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazel-buildtools";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = version;
    sha256 = "sha256-PNIqsP5p+OdYH0JgOmjqvge9zVOrAcNg0FMflXFJHwQ=";
  };

  vendorSha256 = "sha256-9WUjQhXWkpSEJj9Xq+9rOe3I1VZ7nqMTnX7DPl+rxsU=";

  preBuild = ''
    rm -r warn/docs
  '';

  doCheck = false;

  excludedPackages = [ "generatetables" ];

  ldflags = [ "-s" "-w" "-X main.buildVersion=${version}" "-X main.buildScmRevision=${src.rev}" ];

  meta = with lib; {
    description = "Tools for working with Google's bazel buildtool. Includes buildifier, buildozer, and unused_deps";
    homepage = "https://github.com/bazelbuild/buildtools";
    license = licenses.asl20;
    maintainers = with maintainers;
      [ elasticdog uri-canva marsam ]
      ++ lib.teams.bazel.members;
  };
}
