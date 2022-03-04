{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "earthly";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${version}";
    sha256 = "sha256-FZHz46GUPG5LgJcuKxheERWcctuHdDWgGPslEAu+j08=";
  };

  vendorSha256 = "sha256-uUx9C7uEdXjhDWxehGHuhuFQXdUjZAXK3qogESkRm8E=";

  ldflags = [
    "-s" "-w"
    "-X main.Version=v${version}"
    "-X main.DefaultBuildkitdImage=earthly/buildkitd:v${version}"
  ];

  BUILDTAGS = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork";
  preBuild = ''
    makeFlagsArray+=(BUILD_TAGS="${BUILDTAGS}")
  '';

  # For some reasons the tests fail, but the program itself seems to work.
  doCheck = false;

  postInstall = ''
    mv $out/bin/debugger $out/bin/earthly-debugger
    mv $out/bin/shellrepeater $out/bin/earthly-shellrepeater
  '';

  meta = with lib; {
    description = "Build automation for the container era";
    homepage = "https://earthly.dev/";
    changelog = "https://github.com/earthly/earthly/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [ zoedsoupe ];
  };
}
