{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "earthly";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "earthly";
    repo = "earthly";
    rev = "v${version}";
    sha256 = "sha256-zLv0wuAM6d84Z2jCf89KDIIqX+Hiiw40g3DnTZxVTYY=";
  };

  vendorHash = "sha256-NUm+vkJsT78pxrPqwDofPlrc6jQMTFjsRF7uPUPhDGQ=";
  subPackages = [ "cmd/earthly" "cmd/debugger" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
    "-X main.DefaultBuildkitdImage=docker.io/earthly/buildkitd:v${version}"
    "-X main.GitSha=v${version}"
    "-X main.DefaultInstallationName=earthly"
  ] ++ lib.optionals stdenv.isLinux [
    "-extldflags '-static'"
  ];

  tags = [
    "dfrunmount"
    "dfrunnetwork"
    "dfrunsecurity"
    "dfsecrets"
    "dfssh"
  ];

  postInstall = ''
    mv $out/bin/debugger $out/bin/earthly-debugger
  '';

  meta = with lib; {
    description = "Build automation for the container era";
    homepage = "https://earthly.dev/";
    changelog = "https://github.com/earthly/earthly/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ zoedsoupe konradmalik ];
  };
}
