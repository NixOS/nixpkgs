{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "MarkupSafe";
  version = "1.1.1";

 src = fetchPypi {
    inherit pname version;
    sha256 = "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b";
  };

  meta = with lib; {
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = "http://dev.pocoo.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };

}
