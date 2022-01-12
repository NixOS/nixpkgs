{ lib, buildPythonPackage , fetchPypi, pythonOlder
, jupyter_core, pandas, ipywidgets, jupyter }:

buildPythonPackage rec {
  pname = "vega";
  version = "3.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c22877758cef97e81dbb665c83d31f7427bbc804a01503fa2845a35403c54ad";
  };

  propagatedBuildInputs = [ jupyter jupyter_core pandas ipywidgets ];

  # currently, recommonmark is broken on python3
  doCheck = false;
  pythonImportsCheck = [ "vega" ];

  meta = with lib; {
    description = "An IPython/Jupyter widget for Vega and Vega-Lite";
    longDescription = ''
      To use this you have to enter a nix-shell with vega. Then run:

      jupyter nbextension install --user --py vega
      jupyter nbextension enable --user vega
    '';
    homepage = "https://github.com/vega/ipyvega";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.unix;
  };
}
