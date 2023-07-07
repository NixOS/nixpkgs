{ lib, buildPythonPackage , fetchPypi, pythonOlder
, jupyter-core, pandas, ipywidgets, jupyter }:

buildPythonPackage rec {
  pname = "vega";
  version = "3.6.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cO+7Ynbv/+uoNUOPQvDNZji04llHUBlm95Cyfy+Ny80=";
  };

  propagatedBuildInputs = [ jupyter jupyter-core pandas ipywidgets ];

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
