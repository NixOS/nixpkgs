{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
, fetchurl
, terminaltables
, colorclass
, requests
, pyyaml
, setuptools
}:

let

  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v4.63.1/openapi.yaml";
    sha256 = "03ngzbq24zazfqmfd7xjmxixkcb9vv1jgamplsj633j7sjj708s0";
  };

in

buildPythonApplication rec {
  pname = "linode-cli";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "linode";
    repo = pname;
    rev = version;
    sha256 = "1hpdmbzs182iag471yvq3kwd1san04a58sczzbmw6vjv2kswn1c2";
  };

  patches = [
    # make enum34 depend on python version
    ( fetchpatch {
        url = "https://github.com/linode/linode-cli/pull/184/commits/4cf55759c5da33fbc49b9ba664698875d67d4f76.patch";
        sha256 = "04n9a6yh0abyyymvfzajhav6qxwvzjl2vs8jnqp3yqrma7kl0slj";
    })
  ];

  # remove need for git history
  prePatch = ''
    substituteInPlace setup.py \
      --replace "version=get_version()," "version='${version}',"
  '';

  propagatedBuildInputs = [
    terminaltables
    colorclass
    requests
    pyyaml
    setuptools
  ];

  postConfigure = ''
    python3 -m linodecli bake ${spec} --skip-config
    cp data-3 linodecli/
  '';

  # requires linode access token for unit tests, and running executable
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/linode/linode-cli";
    description = "The Linode Command Line Interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryantm ];
  };

}
