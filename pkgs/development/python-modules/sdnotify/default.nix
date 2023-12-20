{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sdnotify";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    sha256 = "1wdrdg2j16pmqhk0ify20s5pngijh7zc6hyxhh8w8v5k8v3pz5vk";
    inherit pname version;
  };

  meta = with lib; {
    description = "A pure Python implementation of systemd's service notification protocol";
    homepage = "https://github.com/bb4242/sdnotify";
    license = licenses.mit;
    maintainers = with maintainers; [ pmiddend ];
  };
}
