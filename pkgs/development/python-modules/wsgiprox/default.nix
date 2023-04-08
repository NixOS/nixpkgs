{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, certauth
}:

buildPythonPackage rec {
  pname = "wsgiprox";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "wsgiprox";
    # https://github.com/webrecorder/wsgiprox/issues/8
    rev = "004870a87959e68ff28ff4362e4f0df28ec22030";
    hash = "sha256-EquddaNrVceyJHuQMCajKHGZX2Q7ebR0Zhvi2pl2WEw=";
  };

  propagatedBuildInputs = [
    six
    certauth
  ];

  pythonImportsCheck = [ "wsgiprox" ];

  # See https://github.com/webrecorder/wsgiprox/issues/6
  doCheck = false;

  meta = with lib; {
    description = "Python WSGI Middleware for adding HTTP/S proxy support to any WSGI Application";
    homepage = "https://github.com/webrecorder/wsgiprox";
    license = licenses.asl20;
    maintainers = with maintainers; [ Luflosi ];
  };
}
