{ lib
, fetchFromGitHub
, aspellDicts
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "codespell";
<<<<<<< HEAD
  version = "2.2.5";
=======
  version = "2.2.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "codespell-project";
    repo = "codespell";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Cu1bbLzVOAvPNzTavaMUfW2SCnQHc9mOM+IHAgVHhT4=";
=======
    sha256 = "sha256-hyTy6zAH5WrW5Jn/g0irH9xGZErnXJMSUYZaNxMvq2Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=codespell_lib" "" \
      --replace "--cov-report=" ""
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  nativeCheckInputs = with python3.pkgs; [
    aspell-python
    chardet
    pytestCheckHook
    pytest-dependency
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  preCheck = ''
    export ASPELL_CONF="dict-dir ${aspellDicts.en}/lib/aspell"
  '';

  disabledTests = [
    # tries to run not fully installed script
    "test_command"
    # error 'dateset' should not be in aspell dictionaries (en, en_GB, en_US, en_CA, en_AU) for dictionary /build/source/codespell_lib/tests/../data/dictionary.txt
    "test_dictionary_formatting"
  ];

  pythonImportsCheck = [ "codespell_lib" ];

  meta = with lib; {
    description = "Fix common misspellings in source code";
    homepage = "https://github.com/codespell-project/codespell";
    license = with licenses; [ gpl2Only cc-by-sa-30 ];
    maintainers = with maintainers; [ johnazoidberg SuperSandro2000 ];
  };
}
