{ stdenv, buildPythonPackage , fetchPypi
, pytest, jupyter_core, pandas }:

buildPythonPackage rec {
  pname = "vega";
  version = "0.4.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08k92afnk0bivm07h1l5nh26xl2rfp7qn03aq17q1hr3fs5r6cdm";
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
