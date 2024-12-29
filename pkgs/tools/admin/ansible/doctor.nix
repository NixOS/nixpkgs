{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ansible-doctor";
  version = "2.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-doctor";
    rev = "refs/tags/v${version}";
    hash = "sha256-nZv1PdR0kGrke2AjcDWjDWBdsw64UpHYFNDFAe/UoJo=";
  };

  patches = [
    # https://github.com/thegeeklab/ansible-doctor/pull/541
    (fetchpatch {
      name = "poetry-dynamic-versioning-pep517.patch";
      url = "https://github.com/thegeeklab/ansible-doctor/commit/b77ba9dccaef4b386bd54b128136c948665eb61a.patch";
      hash = "sha256-XfdTkRk9B857V5DQnxlbwxTb098YwHzKGzNQBTQzWCM=";
    })
  ];

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = with python3.pkgs; [
    anyconfig
    appdirs
    colorama
    environs
    jinja2
    jsonschema
    nested-lookup
    pathspec
    python-json-logger
    ruamel-yaml
  ];

  postInstall = ''
    rm $out/lib/python*/site-packages/LICENSE
  '';

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ansibledoctor"
  ];

  meta = with lib; {
    description = "Annotation based documentation for your Ansible roles";
    mainProgram = "ansible-doctor";
    homepage = "https://github.com/thegeeklab/ansible-doctor";
    changelog = "https://github.com/thegeeklab/ansible-doctor/releases/tag/v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ tboerger ];
  };
}
