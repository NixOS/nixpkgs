{ stdenv, buildPythonPackage, fetchPypi, requests}:

buildPythonPackage rec {
  pname = "update_checker";
  version = "0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f38l40d32dm0avcidf3dmikma8z0la84yngj88v4xygzi399qvh";
  };

  propagatedBuildInputs = [ requests ];

  # requires network
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A python module that will check for package updates";
    homepage = https://github.com/bboe/update_checker;
    license = licenses.bsd2;
  };
}
