{ stdenv, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "116r78nhw74rh857kv9l614xjr6k89919s6l8b14hlvy8fz8rg51";
  };

  meta = with stdenv.lib; {
    description = "Tool to Detect Surrounding Shell";
    homepage = https://github.com/sarugaku/shellingham;
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
