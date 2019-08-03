{ lib, python3Packages, fetchFromGitHub }:
python3Packages.buildPythonApplication rec {
  pname = "dpt-rp1-py";
  version = "unstable-2018-10-16";

  src = fetchFromGitHub {
    owner = "janten";
    repo = pname;
    rev = "4551b4432f8470de5f2ad9171105f731a6259395";
    sha256 = "176y5j31aci1vpi8v6r5ki55432fbdsazh9bsyzr90im9zimkffl";
  };

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    httpsig
    requests
    pbkdf2
    urllib3
  ];

  meta = with lib; {
    homepage = https://github.com/janten/dpt-rp1-py;
    description = "Python script to manage Sony DPT-RP1 without Digital Paper App";
    license = licenses.mit;
    maintainers = with maintainers; [ mt-caret ];
  };
}
