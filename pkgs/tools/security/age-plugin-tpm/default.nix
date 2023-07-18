{ lib
, buildGoModule
, fetchFromGitHub
, swtpm
}:

buildGoModule rec {
  pname = "age-plugin-tpm";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "age-plugin-tpm";
    rev = "v${version}";
    hash = "sha256-Gp7n2/+vgQbsm/En6PQ1to/W6lvFam4Wh3LHdCZnafc=";
  };

  vendorHash = "sha256-oZni/n2J0N3ZxNhf+RlUWyWeOFwL4+6KUIk6DQF8YpA=";

  postConfigure = ''
    substituteInPlace vendor/github.com/foxboron/swtpm_test/swtpm.go \
      --replace "/usr/share/swtpm/swtpm-create-user-config-files" "${swtpm}/share/swtpm/swtpm-create-user-config-files"
  '';

  nativeCheckInputs = [
    swtpm
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
    maintainers = with maintainers; [ kranzes ];
  };
}
