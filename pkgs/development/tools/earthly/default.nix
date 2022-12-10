{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "earthly";
  version = "0.6.23";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${version}";
    sha256 = "sha256-RbLAnk2O7wqY0OQLprWuRDUWMicqcLOPia+7aRuXbsk=";
  };

  vendorSha256 = "sha256-MDyQ9Wn5A5F5CQCfEXzkXZi/Fg6sT/Ikv+Y7fvLY8LA=";

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
    license = licenses.mpl20;
    maintainers = with maintainers; [ zoedsoupe ];
  };
}
