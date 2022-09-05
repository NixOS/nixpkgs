{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "goss";
  version = "0.3.18";

  src = fetchFromGitHub {
    owner = "aelsabbahy";
    repo = pname;
    rev = "v${version}";
    sha256 = "01ssc7rnnwpyhjv96qy8drsskghbfpyxpsahk8s62lh8pxygynhv";
  };

  vendorSha256 = "sha256-zlQMVn4w6syYmntxpeiIc1UTbFrIJzOMg0RVDCICTM8=";

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
