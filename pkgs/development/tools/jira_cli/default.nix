{ lib, libffi, openssl, python3Packages }:
let
  inherit (python3Packages) fetchPypi buildPythonApplication;
in
  buildPythonApplication rec {
    pname = "jira-cli";
    version = "3.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "86f7d4ad7292c9a27bbc265d09e7bcd00ef8159f20172998d85f25aad53b0df6";
    };

    postPatch = ''
      substituteInPlace requirements/main.txt --replace "argparse" ""
    '';

    # Tests rely on VCR cassettes being written during tests. R/O nix store prevents this.
    doCheck = false;
    checkInputs = with python3Packages; [ vcrpy mock hiro ];
    buildInputs = [ libffi openssl ];
    propagatedBuildInputs = with python3Packages; [
      requests six suds-jurko termcolor keyring
      jira  keyrings-alt
    ];

    meta = with lib; {
      description = "A command line interface to Jira";
      homepage = "https://github.com/alisaifee/jira-cli";
      maintainers = with maintainers; [ nyarly ];
      license = licenses.mit;
    };
  }
