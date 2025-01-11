{
  lib,
  buildPythonApplication,
  fetchPypi,
  dnspython,
  pytestCheckHook,
}:

buildPythonApplication rec {
  pname = "nxdomain";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0va7nkbdjgzrf7fnbxkh1140pbc62wyj86rdrrh5wmg3phiziqkb";
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
