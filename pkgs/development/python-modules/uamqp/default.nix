{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy3k
, certifi
, cmake
, enum34
, openssl
, six
, CFNetwork
, CoreFoundation
, Security
}:

buildPythonPackage rec {
  pname = "uamqp";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JNGlpu2HvwTGV77WnAQFyvJImHesE2R+ZwMAlhlyk2U=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Azure/azure-c-shared-utility/commit/52ab2095649b5951e6af77f68954209473296983.patch";
      sha256 = "06pxhdpkv94pv3lhj1vy0wlsqsdznz485bvg3zafj67r55g40lhd";
      stripLen = "2";
      extraPrefix = "src/vendor/azure-uamqp-c/deps/azure-c-shared-utility/";
    })
  ];

  buildInputs = [
    openssl
    certifi
    six
  ] ++ lib.optionals (!isPy3k) [
    enum34
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    CFNetwork
    Security
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "An AMQP 1.0 client library for Python";
    homepage = "https://github.com/Azure/azure-uamqp-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
