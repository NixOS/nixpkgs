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
, pytest
, httpretty
, dmidecode
, pytestCheckHook
, shadow
, cloud-utils
, openssh
}:

let version = "20.3";

in buildPythonApplication {
  pname = "cloud-init";
  inherit version;
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "cloud-init";
    rev = version;
    sha256 = "1fmckxf4q4sxjqs758vw7ca0rnhl9hyq67cqpqzz2v3s1gqzjhm4";
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
    "--prefix PATH : ${lib.makeBinPath [
      dmidecode cloud-utils.guest
    ]}/bin"
  ];

  disabledTests = [
    # tries to create /var
    "test_dhclient_run_with_tmpdir"
    # clears path and fails because mkdir is not found
    "test_path_env_gets_set_from_main"
    # tries to read from /etc/ca-certificates.conf while inside the sandbox
    "test_handler_ca_certs"
  ];

  preCheck = ''
    # TestTempUtils.test_mkdtemp_default_non_root does not like TMPDIR=/build
    export TMPDIR=/tmp
  '';

  meta = {
    homepage = "https://cloudinit.readthedocs.org";
    description = "Provides configuration and customization of cloud instance";
    maintainers = [ lib.maintainers.madjar lib.maintainers.phile314 ];
    platforms = lib.platforms.all;
  };
}
