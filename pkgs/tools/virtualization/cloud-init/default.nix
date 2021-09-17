{ lib
, fetchFromGitHub
, buildPythonApplication
, jinja2
, oauthlib
, configobj
, pyyaml
, requests
, jsonschema
, jsonpatch
, httpretty
, dmidecode
, pytestCheckHook
, shadow
, cloud-utils
, openssh
}:

buildPythonApplication rec {
  pname = "cloud-init";
  version = "21.2";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "cloud-init";
    rev = version;
    sha256 = "0vhjkgs49ixfa3kkj5s3v3gcxvypm3cdvfk6adrk2bx3wv2cbhvz";
  };

  patches = [ ./0001-add-nixos-support.patch ];
  prePatch = ''
    substituteInPlace setup.py --replace /lib/systemd $out/lib/systemd
  '';

  postInstall = ''
    install -D -m755 ./tools/write-ssh-key-fingerprints $out/libexec/write-ssh-key-fingerprints
    for i in $out/libexec/*; do
      wrapProgram $i --prefix PATH : "${lib.makeBinPath [ openssh ]}"
    done
  '';

  propagatedBuildInputs = [
    jinja2
    oauthlib
    configobj
    pyyaml
    requests
    jsonschema
    jsonpatch
  ];

  checkInputs = [
    pytestCheckHook
    httpretty
    dmidecode
    # needed for tests; at runtime we rather want the setuid wrapper
    shadow
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ dmidecode cloud-utils.guest ]}/bin"
  ];

  disabledTests = [
    # tries to create /var
    "test_dhclient_run_with_tmpdir"
    # clears path and fails because mkdir is not found
    "test_path_env_gets_set_from_main"
    # tries to read from /etc/ca-certificates.conf while inside the sandbox
    "test_handler_ca_certs"
    # Doesn't work in the sandbox
    "TestEphemeralDhcpNoNetworkSetup"
    "TestHasURLConnectivity"
    "TestReadFileOrUrl"
    "TestConsumeUserDataHttp"
    # Chef Omnibus
    "TestInstallChefOmnibus"
    # https://github.com/canonical/cloud-init/pull/893
    "TestGetPackageMirrorInfo"
  ];

  disabledTestPaths = [
    # Oracle tests are not passing
    "cloudinit/sources/tests/test_oracle.py"
    # Disable the integration tests. pycloudlib would be required
    "tests/unittests/test_datasource/test_aliyun.py"
    "tests/unittests/test_datasource/test_azure.py"
    "tests/unittests/test_datasource/test_ec2.py"
    "tests/unittests/test_datasource/test_exoscale.py"
    "tests/unittests/test_datasource/test_gce.py"
    "tests/unittests/test_datasource/test_openstack.py"
    "tests/unittests/test_datasource/test_scaleway.py"
    "tests/unittests/test_ec2_util.py"
  ];

  preCheck = ''
    # TestTempUtils.test_mkdtemp_default_non_root does not like TMPDIR=/build
    export TMPDIR=/tmp
  '';

  pythonImportsCheck = [ "cloudinit" ];

  meta = with lib; {
    homepage = "https://cloudinit.readthedocs.org";
    description = "Provides configuration and customization of cloud instance";
    license = with licenses; [ asl20 gpl3Plus ];
    maintainers = with maintainers; [ madjar phile314 ];
    platforms = platforms.all;
  };
}
