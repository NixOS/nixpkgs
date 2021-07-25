{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "earthly";
  version = "0.5.20";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${version}";
    sha256 = "sha256-wPtL5fH6s4qlG82udeg9Gv4iNBjDEeKNTDFHPsW4V/A=";
  };

  vendorSha256 = "sha256-gydhh/EMSuE/beo+A2CRDdDnQGT6DMjMwthylT339I4=";

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X main.Version=v${version}
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v${version}
      -extldflags -static
  '';

  BUILDTAGS = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork";
  preBuild = ''
    makeFlagsArray+=(BUILD_TAGS="${BUILDTAGS}")
  '';

  postInstall = ''
    mv $out/bin/debugger $out/bin/earthly-debugger
    mv $out/bin/shellrepeater $out/bin/earthly-shellrepeater
  '';

  meta = with lib; {
    description = "Build automation for the container era";
    homepage = "https://earthly.dev/";
    changelog = "https://github.com/earthly/earthly/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [ mdsp ];
  };
}
