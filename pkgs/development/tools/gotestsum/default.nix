{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gotestsum";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "gotestyourself";
    repo = "gotestsum";
    rev = "v${version}";
    sha256 = "sha256-BpT5FxqDOLnlWtOHMqwruR/CkD46xEgU7D8sAzsVO14=";
  };

  vendorSha256 = "sha256-zUqa6xlDV12ZV4N6+EZ7fLPsL8U+GB7boQ0qG9egvm0=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X gotest.tools/gotestsum/cmd.version=${version}" ];

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/gotestyourself/gotestsum";
    description = "A human friendly `go test` runner";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ endocrimes ];
  };
}
