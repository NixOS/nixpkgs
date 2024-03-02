{ lib
, buildGoModule
, fetchFromGitHub
, swtpm
, openssl
}:

buildGoModule rec {
  pname = "age-plugin-tpm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "age-plugin-tpm";
    rev = "v${version}";
    hash = "sha256-oTvK8U5j+llHgoChhGb+vcUrUf9doVYxd3d5MEuCNz8=";
  };

  proxyVendor = true;

  vendorHash = "sha256-BSb+8p5+RJMfcYc2+BuT4YbhCWCbcYOt9upesD11Ytw=";

  nativeCheckInputs = [
    swtpm
  ];

  buildInputs = [
    openssl
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "TPM 2.0 plugin for age (This software is experimental, use it at your own risk)";
    homepage = "https://github.com/Foxboron/age-plugin-tpm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kranzes sgo ];
  };
}
