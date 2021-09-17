{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazel-buildtools";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "buildtools";
    rev = version;
    sha256 = "sha256-m6jTDFgjUpQrm77tCnpIRHUFJCFl7GKwu7NoHtoLNa4=";
  };

  vendorSha256 = "sha256-buMkRxVLlS2LBJGaGWeR41BsmE/0vgDS8s1VcRYN0fA=";

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
    maintainers = with maintainers; [ elasticdog uri-canva marsam ];
  };
}
