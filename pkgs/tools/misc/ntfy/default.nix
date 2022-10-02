{ lib
, python39
, fetchFromGitHub
, fetchpatch
}:

let
  python = python39.override {
    packageOverrides = self: super: {
      ntfy-webpush = self.callPackage ./webpush.nix { };
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "ntfy";
  version = "2.7.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "09f02cn4i1l2aksb3azwfb70axqhn7d0d0vl2r6640hqr74nc1cv";
  };

  checkInputs = with python.pkgs; [
    mock
  ];

  propagatedBuildInputs = with python.pkgs; [
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
    # Add compatibility with emoji 2.0
    # https://github.com/dschep/ntfy/pull/250
    (fetchpatch {
      name = "ntfy-Add-compatibility-with-emoji-2.0.patch";
      url = "https://github.com/dschep/ntfy/commit/4128942bb7a706117e7154a50a73b88f531631fe.patch";
      sha256 = "sha256-V8dIy/K957CPFQQS1trSI3gZOjOcVNQLgdWY7g17bRw=";
    })
  ];

  checkPhase = ''
    HOME=$(mktemp -d) ${python.interpreter} setup.py test
  '';

  meta = with lib; {
    description = "A utility for sending notifications, on demand and when commands finish";
    homepage = "http://ntfy.rtfd.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jfrankenau kamilchm ];
  };
}
