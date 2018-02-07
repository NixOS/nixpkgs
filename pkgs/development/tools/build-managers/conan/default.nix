{ lib, buildPythonApplication, fetchPypi
, requests, fasteners, pyyaml, pyjwt, colorama, patch
, bottle, pluginbase, six, distro, pylint, node-semver
, future, pygments, mccabe
}:

buildPythonApplication rec {
  version = "0.28.1";
  pname = "conan";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zf564iqh0099yd779f9fgk21qyp87d7cmgfj34hmncf8y3qh32a";
  };

  propagatedBuildInputs = [
    requests fasteners pyyaml pyjwt colorama patch
    bottle pluginbase six distro pylint node-semver
    future pygments mccabe
  ];

  # enable tests once all of these pythonPackages available:
  # [ nose nose_parameterized mock webtest codecov ]
  doCheck = false;

  meta = with lib; {
    homepage = https://conan.io;
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
