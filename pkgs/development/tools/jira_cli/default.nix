{ stdenv, libffi, openssl, python3Packages }:
let
  inherit (python3Packages) fetchPypi buildPythonApplication vcrpy mock hiro;
in
  buildPythonApplication rec {
    pname = "jira-cli";
    version = "2.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "314118d5d851394ebf910122fd7ce871f63581393968c71456441eb56be3b112";
    };

    postPatch = ''
      substituteInPlace requirements/main.txt --replace "argparse" ""
    '';

    # Tests rely on VCR cassettes being written during tests. R/O nix store prevents this.
    doCheck = false;
    checkInputs = with python3Packages; [ vcrpy mock hiro ];
    buildInputs = [ libffi openssl ];
    propagatedBuildInputs = with python3Packages; [
      ordereddict requests six suds-jurko termcolor keyring
      jira  keyrings-alt
    ];

    meta = with stdenv.lib; {
      description = "A command line interface to Jira";
      homepage = https://github.com/alisaifee/jira-cli;
      maintainers = with maintainers; [ nyarly ];
      license = licenses.mit;
    };
  }
