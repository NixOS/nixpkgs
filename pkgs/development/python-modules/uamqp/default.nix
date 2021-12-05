{ lib, stdenv, buildPythonPackage, certifi, CFNetwork, cmake, CoreFoundation
, enum34, fetchpatch, fetchPypi, isPy3k, openssl, Security, six }:

buildPythonPackage rec {
  pname = "uamqp";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-L4IQWnxRRL3yopNT91Mk8KKdph9Vg2PHkGH+86uDu7c=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs =
    lib.optionals stdenv.isDarwin [ CoreFoundation CFNetwork Security ];

  propagatedBuildInputs = [ certifi openssl six ]
    ++ lib.optionals (!isPy3k) [ enum34 ];

  patches = [
    (fetchpatch {
      url =
        "https://github.com/Azure/azure-c-shared-utility/commit/52ab2095649b5951e6af77f68954209473296983.patch";
      sha256 = "06pxhdpkv94pv3lhj1vy0wlsqsdznz485bvg3zafj67r55g40lhd";
      stripLen = "2";
      extraPrefix = "src/vendor/azure-uamqp-c/deps/azure-c-shared-utility/";
    })
  ];

  dontUseCmakeConfigure = true;

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "uamqp" ];

  meta = with lib; {
    description = "An AMQP 1.0 client library for Python";
    homepage = "https://github.com/Azure/azure-uamqp-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
