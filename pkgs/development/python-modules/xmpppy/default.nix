{ stdenv, buildPythonPackage, fetchurl, isPy3k }:
buildPythonPackage rec {
  pname = "xmpp.py";
  name = "${pname}-${version}";
  version = "0.5.0rc1";

  patches = [ ./ssl.patch ];

  src = fetchurl {
    url = "mirror://sourceforge/xmpppy/xmpppy-${version}.tar.gz";
    sha256 = "16hbh8kwc5n4qw2rz1mrs8q17rh1zq9cdl05b1nc404n7idh56si";
  };

  preInstall = ''
    mkdir -p $out/bin $out/lib $out/share $(toPythonPath $out)
    export PYTHONPATH=$PYTHONPATH:$(toPythonPath $out)
  '';

  disabled = isPy3k;

  meta = with stdenv.lib; {
    description = "XMPP python library";
    homepage = http://xmpppy.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = [ maintainers.mic92 ];
  };
}
