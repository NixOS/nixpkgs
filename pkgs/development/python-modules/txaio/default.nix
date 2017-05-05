{ stdenv, buildPythonPackage, fetchurl,
  pytest, mock, six, twisted
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "txaio";
  version = "2.7.0";

  buildInputs = [ pytest mock ];
  propagatedBuildInputs = [ six twisted ];

  checkPhase = ''
    py.test -k "not test_sdist"
  '';

  src = fetchurl {
    url = "mirror://pypi/t/${pname}/${name}.tar.gz";
    sha256 = "0hwd6jx6hb44p40id9r0m42y07rav5jvddf0f1bcm269i3dnwr47";
  };

  meta = with stdenv.lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio.";
    homepage    = "https://github.com/crossbario/txaio";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
