{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "flare-floss";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "flare-floss";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true; # for tests
    hash = "sha256-bmOWOFqyvOvSrNTbwLqo0WMq4IAZxZ0YYaWCdCrpziU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="

    substituteInPlace floss/main.py \
      --replace 'sigs_path = os.path.join(get_default_root(), "sigs")' 'sigs_path = "'"$out"'/share/flare-floss/sigs"'
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    binary2strings
    halo
    networkx
    pefile
    pydantic
    rich
    tabulate
    tqdm
    viv-utils
    vivisect
  ] ++ viv-utils.optional-dependencies.flirt;

  nativeCheckInputs = with python3.pkgs; [
    pytest-sugar
    pytestCheckHook
    pyyaml
  ];

  postInstall = ''
    mkdir -p $out/share/flare-floss/
    cp -r floss/sigs $out/share/flare-floss/
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Automatically extract obfuscated strings from malware";
    homepage = "https://github.com/mandiant/flare-floss";
    changelog = "https://github.com/mandiant/flare-floss/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "floss";
    maintainers = with maintainers; [ fab ];
  };
}
