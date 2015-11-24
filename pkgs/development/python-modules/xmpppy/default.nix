{ buildPythonPackage, fetchurl, setuptools }:

buildPythonPackage rec {
  name = "xmpp.py-${version}";
  version = "0.5.0rc1";

  src = fetchurl {
    url = "mirror://sourceforge/xmpppy/xmpppy-${version}.tar.gz";
    sha256 = "16hbh8kwc5n4qw2rz1mrs8q17rh1zq9cdl05b1nc404n7idh56si";
  };

  buildInputs = [ setuptools ];

  preInstall = ''
    mkdir -p $out/bin $out/lib $out/share $(toPythonPath $out)
    export PYTHONPATH=$PYTHONPATH:$(toPythonPath $out)
  '';

  meta = {
    description = "XMPP python library";
  };
}
