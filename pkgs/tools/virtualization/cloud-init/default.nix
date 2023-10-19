{ lib
, nixosTests
, buildPythonApplication
, cloud-utils
, dmidecode
, fetchFromGitHub
, iproute2
, openssh
, python3
, shadow
, systemd
, coreutils
, gitUpdater
, busybox
, procps
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloud-init";
  version = "23.3.1";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "cloud-init";
    rev = "refs/tags/${version}";
    hash = "sha256-3UxTqlhLZi/3/buWqDGto4cZN03uONbA8HEWQtaIRxU=";
  };

  patches = [
    ./0001-add-nixos-support.patch
  ];

  prePatch = ''
    substituteInPlace setup.py \
      --replace /lib/systemd $out/lib/systemd

    substituteInPlace cloudinit/net/networkd.py \
      --replace '["/usr/sbin", "/bin"]' '["/usr/sbin", "/bin", "${iproute2}/bin", "${systemd}/bin"]'

    substituteInPlace tests/unittests/test_net_activators.py \
      --replace '["/usr/sbin", "/bin"]' \
        '["/usr/sbin", "/bin", "${iproute2}/bin", "${systemd}/bin"]'

    substituteInPlace tests/unittests/cmd/test_clean.py \
      --replace "/bin/bash" "/bin/sh"
  '';

  postInstall = ''
    install -D -m755 ./tools/write-ssh-key-fingerprints $out/libexec/write-ssh-key-fingerprints
    for i in $out/libexec/*; do
      wrapProgram $i --prefix PATH : "${lib.makeBinPath [ openssh ]}"
    done
  '';

  propagatedBuildInputs = with python3.pkgs; [
    configobj
    jinja2
    jsonpatch
    jsonschema
    netifaces
    oauthlib
    pyserial
    pyyaml
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    httpretty
    dmidecode
    # needed for tests; at runtime we rather want the setuid wrapper
    passlib
    shadow
    responses
    pytest-mock
    coreutils
    procps
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ dmidecode cloud-utils.guest busybox ]}/bin"
  ];

  disabledTests = [
    # tries to create /var
    "test_dhclient_run_with_tmpdir"
    "test_dhcp_client_failover"
    # clears path and fails because mkdir is not found
    "test_path_env_gets_set_from_main"
    # fails to find cat
    "test_subp_combined_stderr_stdout"
    # tries to read from /etc/ca-certificates.conf while inside the sandbox
    "test_handler_ca_certs"
    "TestRemoveDefaultCaCerts"
    # Doesn't work in the sandbox
    "TestEphemeralDhcpNoNetworkSetup"
    "TestHasURLConnectivity"
    "TestReadFileOrUrl"
    "TestConsumeUserDataHttp"
    # Chef Omnibus
    "TestInstallChefOmnibus"
    # https://github.com/canonical/cloud-init/pull/893
    "TestGetPackageMirrorInfo"
    # Disable failing VMware and PuppetAio tests
    "test_get_data_iso9660_with_network_config"
    "test_get_data_vmware_guestinfo_with_network_config"
    "test_get_host_info"
    "test_no_data_access_method"
    "test_install_with_collection"
    "test_install_with_custom_url"
    "test_install_with_default_arguments"
    "test_install_with_no_cleanup"
    "test_install_with_version"
  ];

  preCheck = ''
    # TestTempUtils.test_mkdtemp_default_non_root does not like TMPDIR=/build
    export TMPDIR=/tmp
  '';

  pythonImportsCheck = [
    "cloudinit"
  ];

  passthru = {
    tests = { inherit (nixosTests) cloud-init cloud-init-hostname; };
    updateScript = gitUpdater { ignoredVersions = ".ubuntu.*"; };
  };

  meta = with lib; {
    homepage = "https://github.com/canonical/cloud-init";
    description = "Provides configuration and customization of cloud instance";
    changelog = "https://github.com/canonical/cloud-init/raw/${version}/ChangeLog";
    license = with licenses; [ asl20 gpl3Plus ];
    maintainers = with maintainers; [ illustris jfroche ];
    platforms = platforms.all;
  };
}
