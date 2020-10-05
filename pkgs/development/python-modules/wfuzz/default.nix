{ buildPythonPackage
, chardet
, configparser
, fetchFromGitHub
, future
, isPy27
, lib
, mock
, netaddr
, pkgs
, pyparsing
, pycurl
, pytest
, six
}:

buildPythonPackage rec {
  pname = "wfuzz";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "xmendez";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gddrcppbk1k74qghf1hnl03xbbswm8m9amc3bsja1ajcmk5b63a";
  };

  buildInputs = [ pyparsing configparser ];

  propagatedBuildInputs = [
    chardet
    future
    pycurl
    six
  ];

  checkInputs = [ netaddr pytest ] ++ lib.optionals isPy27 [ mock ];

  # Skip tests requiring a local web server.
  checkPhase = ''
    HOME=$TMPDIR pytest \
      tests/test_{moduleman,filterintro,reqresp,api,clparser,dotdict}.py
  '';

  meta = with lib; {
    description = "Web content fuzzer, to facilitate web applications assessments";
    homepage = "https://wfuzz.readthedocs.io";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
