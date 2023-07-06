{ lib
, fetchPypi
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bloodhound-py";
  version = "1.6.1";

  src = fetchPypi {
    inherit version;
    pname = "bloodhound";
    hash = "sha256-SRP74I5euKJErnSkm6OSdAwznv/ZQeEtNG4XofnIEec=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    ldap3
    dnspython
  ];

  # the package has no tests
  doCheck = false;

  meta = with lib; {
    description = "Ingestor for BloodHound";
    homepage = "https://github.com/fox-it/BloodHound.py";
    license = licenses.mit;
    maintainers = with maintainers; [ exploitoverload ];
  };
}
