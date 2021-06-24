{ buildPythonPackage, fetchFromGitHub, twisted, python-pam }:

buildPythonPackage rec {
  pname = "matrix-synapse-pam";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "14mRh4X0r";
    repo = "matrix-synapse-pam";
    rev = "v${version}";
    sha256 = "10byma9hxz3g4sirw5sa4pvljn83h9vs7zc15chhpl2n14bdx45l";
  };

  propagatedBuildInputs = [ twisted python-pam ];
}
