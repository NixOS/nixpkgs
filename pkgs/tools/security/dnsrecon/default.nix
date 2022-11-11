{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsrecon";
  version = "1.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = pname;
    rev = version;
    hash = "sha256-V4/6VUlMizy8EN8ajN56YF+COn3/dfmD0997R+iR86g=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
    netaddr
    lxml
    setuptools
  ];

  preFixup = ''
    # Install wordlists, etc.
    install -vD namelist.txt subdomains-*.txt snoop.txt -t $out/share/wordlists
  '';

  # Tests require access to /etc/resolv.conf
  doCheck = false;

  pythonImportsCheck = [
    "dnsrecon"
  ];

  meta = with lib; {
    description = "DNS Enumeration script";
    homepage = "https://github.com/darkoperator/dnsrecon";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ c0bw3b fab ];
  };
}
