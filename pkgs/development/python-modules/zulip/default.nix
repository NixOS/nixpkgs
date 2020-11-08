{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, requests
, matrix-client
, distro
}:

buildPythonPackage rec {
  pname = "zulip";
  version = "0.7.0";

  disabled = !isPy3k;

  # no sdist on PyPI
  src = fetchFromGitHub {
    owner = "zulip";
    repo = "python-zulip-api";
    rev = version;
    sha256 = "0waldgpzq3ms1r1z14lxdj56lf082fnmi83l3fn8i8gqr8nvnch1";
  };
  sourceRoot = "source/zulip";

  requiredPythonModules = [
    requests
    matrix-client
    distro
  ];

  preCheck = ''
    export COLUMNS=80
  '';

  meta = with lib; {
    description = "Bindings for the Zulip message API";
    homepage = "https://github.com/zulip/python-zulip-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
