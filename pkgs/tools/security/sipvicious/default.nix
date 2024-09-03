{ lib
, fetchFromGitHub
, installShellFiles
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sipvicious";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = "sipvicious";
    rev = "refs/tags/v${version}";
    hash = "sha256-O8/9Vz/u8BoF1dfGceOJdzPPYLfkdBp2DkwA5WQ3dgo=";
  };

  build-system = [
    installShellFiles
  ] ++ (with python3.pkgs; [
    setuptools
  ]);

  dependencies = with python3.pkgs; [
    scapy
  ];

  postInstall = ''
    installManPage man1/*.1

    # Alias kali linux's binary names
    # https://salsa.debian.org/debian/sipvicious/-/blob/9f821cd91e5519d5d19e9cdc0272eeb95ddcccf5/debian/sipvicious.links
    for p in svcrack svcrash svmap svreport svwar; do
      ln -s "$out/bin/sipvicious_$p" "$out/bin/$p"
    done
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sipvicious"
  ];

  meta = with lib; {
    description = "Set of tools to audit SIP based VoIP systems";
    homepage = "https://github.com/EnableSecurity/sipvicious";
    changelog = "https://github.com/EnableSecurity/sipvicious/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
