{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnsrecon";
<<<<<<< HEAD
  version = "1.1.5";
=======
  version = "1.1.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "darkoperator";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-W7ZFc+kF00ANoYVTlsY+lJ9FjMEGbqYfNojoZFiRHU8=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "flake8" "" \
      --replace "pytest" ""
  '';

=======
    hash = "sha256-DtyYYNtv0Zk8103NN+vlnr3Etv0bAZ6+A2CXeZZgiUg=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
