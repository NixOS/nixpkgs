{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  python3,
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      paramiko = super.paramiko.overridePythonAttrs (oldAttrs: rec {
        version = "3.3.1";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-ajd3qWGshtvvN1xfW41QAUoaltD9fwVKQ7yIATSw/3c=";
        };
        patches = [
          (fetchpatch {
            name = "Use-pytest-s-setup_method-in-pytest-8-the-nose-method-setup-is-deprecated.patch";
            url = "https://github.com/paramiko/paramiko/pull/2349.diff";
            hash = "sha256-4CTIZ9BmzRdh+HOwxSzfM9wkUGJOnndctK5swqqsIvU=";
          })

        ];
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python3.pkgs.icecream ];
      });
    };
  };
in
with py.pkgs;


buildPythonApplication rec {
  pname = "ssh-mitm";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ssh-mitm";
    repo = "ssh-mitm";
    rev = "refs/tags/${version}";
    hash = "sha256-Uf1B7oEZyNWj4TjrLvEfFdxsvsGeMLXFsSdxGLUV4ZU=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  propagatedBuildInputs = [
    argcomplete
    colored
    packaging
    paramiko
    pytz
    pyyaml
    python-json-logger
    rich
    tkinter
    setuptools
    sshpubkeys
    wrapt
  ] ++ lib.optionals stdenv.isDarwin [ setuptools ];
  # fix for darwin users

  nativeBuildInputs = [ installShellFiles ];

  # Module has no tests
  doCheck = false;
  # Install man page
  postInstall = ''
    installManPage man1/*
  '';

  pythonImportsCheck = [ "sshmitm" ];

  meta = with lib; {
    description = "Tool for SSH security audits";
    homepage = "https://github.com/ssh-mitm/ssh-mitm";
    changelog = "https://github.com/ssh-mitm/ssh-mitm/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
