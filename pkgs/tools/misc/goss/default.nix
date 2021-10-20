{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "goss";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "aelsabbahy";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m5w5vwmc9knvaihk61848rlq7qgdyylzpcwi64z84rkw8qdnj6p";
  };

  vendorSha256 = "1lyqjkwj8hybj5swyrv6357hs8sxmf4wim0c8yhfb9mv7fsxhrv7";

  CGO_ENABLED = 0;
  ldflags = [
    "-s" "-w" "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/aelsabbahy/goss/";
    changelog = "https://github.com/aelsabbahy/goss/releases/tag/v${version}";
    description = "Quick and easy server validation";
    longDescription = ''
      Goss is a YAML based serverspec alternative tool for validating a server’s configuration.
      It eases the process of writing tests by allowing the user to generate tests from the current system state.
      Once the test suite is written they can be executed, waited-on, or served as a health endpoint.
    '';
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hyzual jk ];
  };
}
