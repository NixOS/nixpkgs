{ lib
, buildPythonPackage
, fetchPypi
, ruamel_yaml
, pyqt5
}:

buildPythonPackage rec {
  pname = "whither";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07ybxf5280dq6ismmm38r6xkd4s395l3yi3h0df5ff41da0ra93h";
  };

  patches = [
    # Qt 5.11 "broke file:// url access".
    #  → https://github.com/Antergos/whither/commit/bf4000dbd8c0963528c17419d0ccb6395fd8bb47
    # Disables the interceptor meanwhile.
    # (This will need to be fixed by upstream before this gets in nixpkgs imho)
    ./5.11_hacky_fix.patch
  ];

  propagatedBuildInputs = [
    ruamel_yaml
    pyqt5
  ];

  # I'm not sure why we don't find PyQt5 here but there's a similar
  # sed on other packages.
  postPatch = "sed -i /PyQt5/d setup.py";


  meta = with lib; {
    homepage = "https://github.com/Antergos/whither";
    description = "Universal Linux Application SDK";
    license = licenses.gpl3;
    maintainers = with maintainers; [ samueldr ];
  };
}
