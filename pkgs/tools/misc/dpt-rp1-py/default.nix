{ lib, python3Packages, fetchFromGitHub }:
python3Packages.buildPythonApplication rec {
  pname = "dpt-rp1-py";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "janten";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xw853s5bx2lr57w6ldfjzi1ppc6px66zd7hzk8y2kg82q6bnasq";
  };

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    anytree
    fusepy
    httpsig
    pbkdf2
    pyyaml
    requests
    tqdm
    urllib3
    zeroconf
  ];

  meta = with lib; {
    homepage = "https://github.com/janten/dpt-rp1-py";
    description = "Python script to manage Sony DPT-RP1 without Digital Paper App";
    license = licenses.mit;
    maintainers = with maintainers; [ mt-caret ];
  };
}
