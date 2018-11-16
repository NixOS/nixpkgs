{ stdenv, buildPythonPackage , fetchPypi
, pytest, jupyter_core, pandas }:

buildPythonPackage rec {
  pname = "vega";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf9701dac0111c09ea009ab06cbb81f27b1d9c23ebf58ebdf08b6994a37f13ac";
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
