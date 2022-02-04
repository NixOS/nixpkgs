{ lib, python3Packages, fetchFromGitHub, fetchpatch }:

python3Packages.buildPythonApplication rec {
  pname = "ntfy";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "09f02cn4i1l2aksb3azwfb70axqhn7d0d0vl2r6640hqr74nc1cv";
  };

  checkInputs = with python3Packages; [
    mock
  ];

  propagatedBuildInputs = with python3Packages; [
    requests ruamel-yaml appdirs
    sleekxmpp dnspython
    emoji
    psutil
    matrix-client
    dbus-python
    ntfy-webpush
    slack-sdk
  ];

  patches = [
    # Fix Slack integration no longer working.
    # From https://github.com/dschep/ntfy/pull/229 - "Swap Slacker for Slack SDK"
    (fetchpatch {
      name = "ntfy-Swap-Slacker-for-Slack-SDK.patch";
      url = "https://github.com/dschep/ntfy/commit/2346e7cfdca84c8f1afc7462a92145c1789deb3e.patch";
      sha256 = "13k7jbsdx0jx7l5s8whirric76hml5bznkfcxab5xdp88q52kpk7";
    })
  ];

  checkPhase = ''
    HOME=$(mktemp -d) ${python3Packages.python.interpreter} setup.py test
  '';

  meta = with lib; {
    description = "A utility for sending notifications, on demand and when commands finish";
    homepage = "http://ntfy.rtfd.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jfrankenau kamilchm ];
  };
}
