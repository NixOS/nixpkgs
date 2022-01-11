{ lib
, buildPythonPackage
, fetchPypi
, jupyterhub
, notebook
, escapism
}:

buildPythonPackage rec {
  pname = "sudospawner";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5dbddd8164e05e4bb3a31eeb1a5baf5a5c6268f1cd14b3f063cde609b8bfbbe1";
  };

  propagatedBuildInputs = [
    jupyterhub
    escapism
    notebook
  ];

  # tests require sudo
  doCheck = false;

  meta = with lib; {
    description = "Spawner for JupyterHub using sudo";
    homepage = "https://jupyter.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.abbradar ];
  };
}
