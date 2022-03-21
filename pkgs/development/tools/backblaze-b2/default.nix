{ fetchFromGitHub, lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "3.2.0";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "b2";
    sha256 = "sha256-dE4eLTNU6O0DscwN8+m1UaG46dbI0DiWzeJK49GUvKA=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'docutils==0.16' 'docutils'
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm'
  '';

  propagatedBuildInputs = with python3Packages; [
    b2sdk
    phx-class-registry
    setuptools
    docutils
    rst2ansi
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_files_headers"
    "test_integration"
    "test_get_account_info"
  ];

  postInstall = ''
    mv "$out/bin/b2" "$out/bin/backblaze-b2"

    sed 's/b2/backblaze-b2/' -i contrib/bash_completion/b2

    mkdir -p "$out/share/bash-completion/completions"
    cp contrib/bash_completion/b2 "$out/share/bash-completion/completions/backblaze-b2"
  '';

  meta = with lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage = "https://github.com/Backblaze/B2_Command_Line_Tool";
    license = licenses.mit;
    maintainers = with maintainers; [ hrdinka kevincox ];
    platforms = platforms.unix;
  };
}
