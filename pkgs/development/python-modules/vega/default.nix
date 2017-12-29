{ stdenv, buildPythonPackage , fetchPypi
, pytest, jupyter_core, pandas }:

buildPythonPackage rec {
  pname = "vega";
  version = "0.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9871bce3a00bb775d9f7f8212aa237f99f11ca7cfe6ecf246773f5559f20c38c";
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
