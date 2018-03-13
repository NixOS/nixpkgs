{ lib, buildPythonApplication, fetchPypi
, requests, fasteners, pyyaml, pyjwt, colorama, patch
, bottle, pluginbase, six, distro11, pylint, node-semver2
, future, pygments, mccabe
, fetchpatch
}:

buildPythonApplication rec {
  version = "1.1.1";
  pname = "conan";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k1r401bc9fgmhd5n5f29mjcn346r3zdrm7p28nwpr2r2p3fslrl";
  };

  propagatedBuildInputs = [
    requests fasteners pyyaml pyjwt colorama patch
    bottle pluginbase six distro11 pylint node-semver2
    future pygments mccabe
  ];

  # enable tests once all of these pythonPackages available:
  # [ nose nose_parameterized mock webtest codecov ]
  # update 2018-03-11: only nose_parameterized is missing
  doCheck = false;

  meta = with lib; {
    homepage = https://conan.io;
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
