{ stdenv, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x1hja3jzvh7xmd0sxnfw9hi3k419s95vb7jjzh76yydzvss1r2q";
  };

  meta = with stdenv.lib; {
    description = "Tool to Detect Surrounding Shell";
    homepage = https://github.com/sarugaku/shellingham;
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
