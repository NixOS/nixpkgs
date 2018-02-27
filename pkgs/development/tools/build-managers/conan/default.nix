{ lib, buildPythonApplication, fetchPypi
, requests, fasteners, pyyaml, pyjwt, colorama, patch
, bottle, pluginbase, six, distro, pylint, node-semver
, future, pygments, mccabe
}:

buildPythonApplication rec {
  version = "1.0.4";
  pname = "conan";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f5cea887ecd6285bd83ae2acc3f76ed06dd52a79c106fe686d210b3ead89060";
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
