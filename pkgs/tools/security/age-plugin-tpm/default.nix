{ lib
, buildGoModule
, fetchFromGitHub
, swtpm
}:

buildGoModule {
  pname = "age-plugin-tpm";
  version = "unstable-2023-05-02";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "age-plugin-tpm";
    rev = "c570739b05c067087c44f651efce6890eedc0647";
    hash = "sha256-xlJtyNAYi/6vBWLsjymFLGfr30w80OplwG2xGTEB118=";
  };

  vendorHash = "sha256-S9wSxw0ZMibCOspgGt5vjzFhPL+bZncjTdIX2mkX5vE=";

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
    description = "TPM 2.0 plugin for age";
    homepage = "https://github.com/Foxboron/age-plugin-tpm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kranzes ];
  };
}
