{ stdenv, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "0.21.2";
  pname = "conan";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0x9s5h81d885xdrjw5x99q18lhmj11kalrs6xnjy2phrr8qzil8c";
  };

  propagatedBuildInputs = with pythonPackages; [
    requests fasteners pyyaml pyjwt colorama patch
    bottle pluginbase six distro pylint node-semver
  ];

  # enable tests once all of these pythonPackages available:
  # [ nose nose_parameterized mock WebTest codecov ]
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://conan.io;
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
