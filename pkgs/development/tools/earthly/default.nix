{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "earthly";
  version = "0.5.17";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${version}";
    sha256 = "sha256-SuHHeO2KFjB3HbLv1ODBGaXzNaDi/FNPOGg/lX8JLJE=";
  };

  vendorSha256 = "sha256-D62fG+T3G1W7xteSGlTtEkXbQfGAmBTYJeATH2CVtwY=";

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
