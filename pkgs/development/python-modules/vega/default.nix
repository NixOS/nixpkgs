{ stdenv, buildPythonPackage , fetchPypi, pythonOlder
, pytest, jupyter_core, pandas, ipywidgets }:

buildPythonPackage rec {
  pname = "vega";
  version = "3.4.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f343ceb11add58d24cd320d69e410b111a56c98c9069ebb4ef89c608c4c1950d";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ jupyter_core pandas ipywidgets ];

  meta = with stdenv.lib; {
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
