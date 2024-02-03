{ lib
, buildPythonPackage
, fetchFromGitHub
, libredirect
, systemd
, pkg-config
, pytest
, python
}:

buildPythonPackage rec {
  pname = "systemd";
  version = "235";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "python-systemd";
    rev = "v${version}";
    hash = "sha256-8p4m4iM/z4o6PHRQIpuSXb64tPTWGlujEYCDVLiIt2o=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    systemd
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    echo "12345678901234567890123456789012" > machine-id
    export NIX_REDIRECTS=/etc/machine-id=$(realpath machine-id) \
    LD_PRELOAD=${libredirect}/lib/libredirect.so

    # Those tests assume /etc/machine-id to be available
    # But our redirection technique does not work apparently
    pytest $out/${python.sitePackages}/systemd -k 'not test_get_machine and not test_get_machine_app_specific and not test_reader_this_machine'
  '';

  pythonImportsCheck = [
    "systemd.journal"
    "systemd.id128"
    "systemd.daemon"
    "systemd.login"
  ];

  meta = with lib; {
    description = "Python module for native access to the systemd facilities";
    homepage = "https://www.freedesktop.org/software/systemd/python-systemd/";
    changelog = "https://github.com/systemd/python-systemd/blob/v${version}/NEWS";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
