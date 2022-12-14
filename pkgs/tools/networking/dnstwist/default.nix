{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnstwist";
  version = "20221022";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "elceef";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-qdKMEE97PWkWgstJZxnFWDjc2heIbJjjCwBbl5K2zy4=";
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

  pythonImportsCheck = [
    "dnstwist"
  ];

  meta = with lib; {
    description = "Domain name permutation engine for detecting homograph phishing attacks";
    homepage = "https://github.com/elceef/dnstwist";
    changelog = "https://github.com/elceef/dnstwist/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
