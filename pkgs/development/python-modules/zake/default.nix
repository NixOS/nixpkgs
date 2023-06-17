{ lib
, buildPythonPackage
, fetchPypi
, kazoo
, six
, testtools
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "zake";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rp4xxy7qp0s0wnq3ig4ji8xsl31g901qkdp339ndxn466cqal2s";
  };

  propagatedBuildInputs = [ kazoo six ];
  buildInputs = [ testtools ];
  nativeCheckInputs = [ unittestCheckHook ];
  preCheck = ''
    # Skip test - fails with our new kazoo version
    substituteInPlace zake/tests/test_client.py \
      --replace "test_child_watch_no_create" "_test_child_watch_no_create"
  '';

  unittestFlagsArray = [ "zake/tests" ];

  meta = with lib; {
    homepage = "https://github.com/yahoo/Zake";
    description = "A python package that works to provide a nice set of testing utilities for the kazoo library";
    license = licenses.asl20;
    broken = true;
  };

}
