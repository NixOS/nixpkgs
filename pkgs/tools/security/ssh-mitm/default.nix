{ lib
, fetchFromGitHub
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      paramiko = super.paramiko.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.0";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-aVD6ymgZrNMhnUrmlKI8eofuONCE9wwXJLDA27i3V2k=";
        };
        patches = [ ];
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python3.pkgs.icecream ];
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "ssh-mitm";
  version = "3.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-koV7g6ZmrrXk60rrDP8BwrDZk3shiyJigQgNcb4BASE=";
  };

  propagatedBuildInputs = [
    argcomplete
    colored
    packaging
    paramiko
    pytz
    pyyaml
    rich
    setuptools
    sshpubkeys
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sshmitm"
  ];

  meta = with lib; {
    description = "Tool for SSH security audits";
    homepage = "https://github.com/ssh-mitm/ssh-mitm";
    changelog = "https://github.com/ssh-mitm/ssh-mitm/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
