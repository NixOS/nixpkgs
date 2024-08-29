{
  lib,
  stdenv,
  automat,
  buildPythonPackage,
  cryptography,
  fetchpatch2,
  fetchPypi,
  geoip,
  incremental,
  lsof,
  mock,
  pytestCheckHook,
  pythonOlder,
  twisted,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "txtorcon";
  version = "23.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cfha6T121yZRAFnJ7XTmCLxaXJ99EDhTtJ5BQoBAai8=";
  };

  patches = [
    # https://github.com/meejah/txtorcon/pull/400
    (fetchpatch2 {
      name = "twisted-24.7.0-fixes.patch";
      url = "https://github.com/meejah/txtorcon/commit/88b5dc2971514babd36d837c93550715dea44b09.patch";
      hash = "sha256-O7kFZw+y1PHJRcMdxCczy8UZd3ruLhjLMxh2tcawWI4=";
    })
  ];

  propagatedBuildInputs = [
    cryptography
    incremental
    twisted
    automat
    zope-interface
  ] ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    pytestCheckHook
    mock
    lsof
    geoip
  ];

  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  meta = with lib; {
    description = "Twisted-based Tor controller client, with state-tracking and configuration abstractions";
    homepage = "https://github.com/meejah/txtorcon";
    changelog = "https://github.com/meejah/txtorcon/releases/tag/v${version}";
    maintainers = with maintainers; [
      jluttine
      exarkun
    ];
    license = licenses.mit;
  };
}
