{ stdenv, buildPythonPackage , fetchPypi
, pytest, jupyter_core, pandas }:

buildPythonPackage rec {
  pname = "vega";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c5561238fbd4a0669aea457decb47c5155e9741b47a41f23cc030387f725edc";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ jupyter_core pandas ];

  meta = with stdenv.lib; {
    description = "An IPython/Jupyter widget for Vega and Vega-Lite";
    longDescription = ''
      To use this you have to enter a nix-shell with vega. Then run:

      jupyter nbextension install --user --py vega
      jupyter nbextension enable --user vega
    '';
    homepage = https://github.com/vega/ipyvega;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.linux;
  };
}
