{ stdenv, buildPythonPackage , fetchPypi
, pytest, jupyter_core, pandas, ipywidgets }:

buildPythonPackage rec {
  pname = "vega";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c66354d6d164cc3d7254bcd129d8d861daf4a9e9cb8738b1724791777f6c29f0";
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
    homepage = https://github.com/vega/ipyvega;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.unix;
  };
}
