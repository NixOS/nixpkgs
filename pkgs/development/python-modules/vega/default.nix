{ stdenv, buildPythonPackage , fetchPypi
, pytest, jupyter_core, pandas }:

buildPythonPackage rec {
  pname = "vega";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lshwsvi242m0ybrqjvbag73x1mrb31w2jq3lnklqyzry153xfdb";
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
    platforms = platforms.unix;
  };
}
