{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, fetchpatch
, rustPlatform
, pkg-config
, openssl
, CoreServices
, Security
, click
, click-log
, click-threading
, requests_toolbelt
, requests
, requests_oauthlib # required for google oauth sync
, atomicwrites
, milksnake
, shippai
, hypothesis
, pytest
, pytest-localserver
, pytest-subtesthack
, setuptools_scm
}:

# Packaging documentation at:
# https://github.com/untitaker/vdirsyncer/blob/master/docs/packaging.rst
buildPythonPackage rec {
  version = "unstable-2018-08-05";
  pname = "vdirsyncer";
  name = "${pname}-${version}";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "spk";
    repo = pname;
    # fix-build-style branch, see https://github.com/pimutils/vdirsyncer/pull/798
    rev = "2c62d03bd73f8b44a47c2e769ade046697896ae9";
    sha256 = "1q6xvzz5rf5sqdaj3mdvhpgwy5b16isavgg7vardgjwqwv1yal28";
  };

  native = rustPlatform.buildRustPackage {
    name = "${name}-native";
    inherit src;
    sourceRoot = "source/rust";
    cargoSha256 = "0cqy0s55pkg6hww86h7qip4xaidh6g8lcypdj84n2x374jq38c5d";
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];
  };

  propagatedBuildInputs = [
    click click-log click-threading
    requests_toolbelt
    requests
    requests_oauthlib # required for google oauth sync
    atomicwrites
    milksnake
    shippai
  ];

  nativeBuildInputs = [
    setuptools_scm
  ];

  checkInputs = [
    hypothesis
    pytest
    pytest-localserver
    pytest-subtesthack
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/pimutils/vdirsyncer/commit/7b636e8e40d69c495901f965b9c0686513659e44.patch";
      sha256 = "0vl942ii5iad47y63v0ngmhfp37n30nxyk4j7h64b95fk38vfwx9";
    })
  ];

  postPatch = ''
    # see https://github.com/pimutils/vdirsyncer/pull/805
    substituteInPlace setup.cfg --replace --duration --durations

    # for setuptools_scm:
    echo 'Version: ${version}' >PKG-INFO

    sed -i 's/spec.add_external_build(cmd=cmd/spec.add_external_build(cmd="true"/g' setup.py

    # fixing test
    sed -i "s/invalid value for \"--verbosity\"/invalid value for \\\'--verbosity\\\'/" tests/system/cli/test_sync.py
  '';

  preBuild = ''
    mkdir -p rust/target/release
    ln -s ${native}/lib/libvdirsyncer_rustext* rust/target/release/
  '';

  checkPhase = ''
    rm -rf vdirsyncer
    make DETERMINISTIC_TESTS=true PYTEST_ARGS="--deselect=tests/unit/utils/test_vobject.py::test_replace_uid --deselect=tests/unit/sync/test_sync.py::TestSyncMachine" test
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/pimutils/vdirsyncer";
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ matthiasbeyer gebner ];
    license = licenses.mit;
  };
}
