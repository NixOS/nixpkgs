{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "backblaze-b2";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "v${version}";
    sha256 = "sha256-KUdDwxVFO4QJ+hKcCWYaxksw9wC67PLmYimrfP++WfQ=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    b2sdk
    class-registry
    docutils
    phx-class-registry
    rst2ansi
    setuptools
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm' \
      --replace "use_scm_version=True," 'version="${version}",'
    substituteInPlace requirements.txt \
      --replace "arrow>=0.8.0,<1.0.0" "arrow"
  '';

  disabledTests = [
    "test_files_headers"
    "test_integration"
    # arrow > 1.0.2 has breaking changes, https://github.com/Backblaze/B2_Command_Line_Tool/issues/687
    "test_parse_millis_from_float_timestamp"
    "test_sync_exclude_if_modified_after_exact"
    "test_sync_exclude_if_modified_after_in_range"
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
