{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnstwist";
  version = "20201228";
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "elceef";
    repo = pname;
    rev = version;
    sha256 = "0bxshi1p0va2f449v6vsm8bav5caa3r3pyknj3zf4n5rvk6say70";
  };

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
    GeoIP
    ppdeep
    requests
    tld
    whois
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "dnstwist" ];

  meta = with lib; {
    description = "Domain name permutation engine for detecting homograph phishing attacks";
    homepage = "https://github.com/elceef/dnstwist";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
