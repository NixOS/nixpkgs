{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, yara
}:

buildGoModule rec {
  pname = "spyre";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "spyre-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "0iijvwcybp9z70jdh5mkaj7k3cw43r72wg3ayhnpyjmvgrwij43i";
  };

  vendorSha256 = "1mssfiph4a6jqp2qlrksvzinh0h8qpwdaxa5zx7fsydmqvk93w0g";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    yara
  ];

  meta = with lib; {
    description = "YARA-based IOC scanner";
    homepage = "https://github.com/spyre-project/spyre";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
