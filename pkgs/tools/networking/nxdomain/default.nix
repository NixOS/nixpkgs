{ lib, buildPythonApplication, fetchPypi, dnspython, pytestCheckHook }:

buildPythonApplication rec {
  pname = "nxdomain";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z9iffggqq2kw6kpnj30shi98cg0bkvkwpglmhnkgwac6g55n2zn";
  };

  propagatedBuildInputs = [ dnspython ];

  checkInputs = [ pytestCheckHook ];

  postCheck = ''
    echo example.org > simple.list
    python -m nxdomain --format dnsmasq --out dnsmasq.conf --simple ./simple.list
    grep -q 'address=/example.org/' dnsmasq.conf
  '';

  meta = with lib; {
    homepage = "https://github.com/zopieux/nxdomain";
    description = "A domain (ad) block list creator";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zopieux ];
  };
}
