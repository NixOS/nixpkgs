{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "flare-floss";
  version = "2.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "flare-floss";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true; # for tests
    hash = "sha256-tOLnve5XBc3TtSgucPIddBHD0YJhsRpRduXsKrtJ/eQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="

    substituteInPlace floss/main.py \
      --replace 'sigs_path = os.path.join(get_default_root(), "sigs")' 'sigs_path = "'"$out"'/share/flare-floss/sigs"'
  '';

  propagatedBuildInputs = with python3.pkgs; [
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

  meta = with lib; {
    description = "Automatically extract obfuscated strings from malware";
    homepage = "https://github.com/mandiant/flare-floss";
    changelog = "https://github.com/mandiant/flare-floss/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "floss";
    maintainers = with maintainers; [ fab ];
  };
}
