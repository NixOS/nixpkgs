{ stdenv, buildPythonPackage, fetchurl,
  pytest, mock, six, twisted
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "txaio";
  version = "2.7.1";

  buildInputs = [ pytest mock ];
  propagatedBuildInputs = [ six twisted ];

  checkPhase = ''
    py.test -k "not test_sdist"
  '';

  src = fetchurl {
    url = "mirror://pypi/t/${pname}/${name}.tar.gz";
    sha256 = "9eea85c27ff8ac28049a29b55383f5c162351f855860e5081ff4632d65a5b4d2";
  };

  meta = with stdenv.lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio.";
    homepage    = "https://github.com/crossbario/txaio";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
