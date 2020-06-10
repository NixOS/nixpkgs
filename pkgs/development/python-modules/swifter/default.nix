{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, nose,
  pandas, psutil, dask, tqdm, ipywidgets, numba, bleach, parso, distributed }:
buildPythonPackage rec {
  version = "0.304";
  pname = "swifter";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fe99d18e8716e82bce5a76322437d180c25ef1e29f1e4c5d5dd007928a316e9";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ pandas psutil dask tqdm ipywidgets numba bleach parso distributed ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "swifter" ];
  checkPhase = ''
    nosetests
  '';

  # Tests require extra dependencies
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/jmcarpenter2/swifter";
    description = "A package which efficiently applies any function to a pandas dataframe or series in the fastest available manner";
    license = licenses.mit;
    maintainers = [ maintainers.moritzs ];
  };
}
