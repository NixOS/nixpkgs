{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "earthly";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${version}";
    sha256 = "sha256-p2O9GkXrRCxgOnVVmtBFUpbg0w9b3LB0PNOlK1gxYAY=";
  };

  vendorSha256 = "sha256-avxNVTPcJ5HjeN7Q9rVmmSud1i3Yb8cSFTAUtNPYbBg=";

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
    license = licenses.mpl20;
    maintainers = with maintainers; [ mdsp ];
  };
}
