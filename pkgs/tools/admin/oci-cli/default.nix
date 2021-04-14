{ lib, fetchFromGitHub, python3Packages, locale }:

let
  # https://github.com/oracle/oci-cli/issues/189
  pinned_click = python3Packages.click.overridePythonAttrs (old: rec {
    pname = "click";
    version = "6.7";
    src = python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-8VUW30eNWlYYD7+A5o8gYBDm0WD8OfpQi2XgNf11Ews=";
    };

    postPatch = ''
      substituteInPlace click/_unicodefun.py \
      --replace "'locale'" "'${locale}/bin/locale'"
    '';

    # Issue that wasn't resolved when this version was released:
    # https://github.com/pallets/click/issues/823
    doCheck = false;
  });
in

python3Packages.buildPythonApplication rec {
  pname = "oci-cli";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "oci-cli";
    rev = "v${version}";
    hash = "sha256-XRkycJrUSOZQAGiSyQZGA/SnlxnFumYL82kOkYd7s2o=";
  };

  propagatedBuildInputs = with python3Packages; [
    oci arrow certifi pinned_click configparser cryptography jmespath dateutil
    pytz retrying six terminaltables pyopenssl pyyaml
  ];

  # https://github.com/oracle/oci-cli/issues/187
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "configparser==4.0.2" "configparser" \
      --replace "cryptography==3.2.1" "cryptography" \
      --replace "pyOpenSSL==19.1.0" "pyOpenSSL" \
      --replace "PyYAML==5.3.1" "PyYAML" \
      --replace "six==1.14.0" "six"
  '';

  meta = with lib; {
    description = "Command Line Interface for Oracle Cloud Infrastructure";
    homepage = "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm";
    maintainers = with maintainers; [ ilian ];
    license = with licenses; [ asl20 upl ];
  };
}
