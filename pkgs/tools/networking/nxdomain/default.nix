{ lib, buildPythonApplication, fetchPypi, dnspython, pytestCheckHook }:

buildPythonApplication rec {
  pname = "nxdomain";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a+L4I7zjVV5gzi0bJD0Xhq0LSAhw9mXdcfk/2da0R20=";
  };

  propagatedBuildInputs = [ dnspython ];

  nativeCheckInputs = [ pytestCheckHook ];

  postCheck = ''
    echo example.org > simple.list
    python -m nxdomain --format dnsmasq --out dnsmasq.conf --simple ./simple.list
    grep -q 'address=/example.org/' dnsmasq.conf
  '';

  meta = with lib; {
    homepage = "https://github.com/zopieux/nxdomain";
    description = "Domain (ad) block list creator";
    mainProgram = "nxdomain";
    platforms = platforms.all;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zopieux ];
  };
}
