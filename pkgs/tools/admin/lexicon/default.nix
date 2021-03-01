{ lib
, python3
, fetchFromGitHub
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      # until https://github.com/ags-slc/localzone/issues/1 gets resolved
      dnspython = super.dnspython.overridePythonAttrs(oldAttrs: rec {
        pname = "dnspython";
        version = "1.16.0";
        # since name is defined from the previous derivation, need to override
        # name explicity for correct version to show in drvName
        name = "${pname}-${version}";

        src = super.fetchPypi {
          inherit pname version;
          extension = "zip";
          sha256 = "00cfamn97w2vhq3id87f10mjna8ag5yz5dw0cy5s0sa3ipiyii9n";
        };
      });

      localzone = super.localzone.overridePythonAttrs(oldAttrs: rec {
        meta = oldAttrs.meta // { broken = false; };
      });
    };
  };
in
  with py.pkgs;

buildPythonApplication rec {
  pname = "lexicon";
  version = "3.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jsc2ybbf3mbvgzkgliria494dpj23mgqnw2lh43cnd9rgsjvzn3";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    boto3
    cryptography
    dnspython
    future
    localzone
    pynamecheap
    pyyaml
    requests
    softlayer
    tldextract
    transip
    xmltodict
    zeep
  ];

  checkInputs = [
    mock
    pytest
    pytestcov
    pytest_xdist
    vcrpy
  ];

  checkPhase = ''
    pytest --ignore=lexicon/tests/providers/test_auto.py
  '';

  meta = with lib; {
    description = "Manipulate DNS records on various DNS providers in a standardized way";
    homepage = "https://github.com/AnalogJ/lexicon";
    maintainers = with maintainers; [ flyfloh ];
    license = licenses.mit;
  };
}
