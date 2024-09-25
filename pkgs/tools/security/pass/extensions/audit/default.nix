{
  lib,
  stdenv,
  pass,
  fetchFromGitHub,
  python3,
  gnupg,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pass-audit";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-audit";
    rev = "v${version}";
    hash = "sha256-xigP8LxRXITLF3X21zhWx6ooFNSTKGv46yFSt1dd4vs=";
  };

  patches = [
    ./0001-Set-base-to-an-empty-value.patch
    ./0002-Fix-audit.bash-setup.patch
  ];

  postPatch = ''
    substituteInPlace audit.bash \
      --replace-fail python3 "${lib.getExe python3}"
    rm Makefile
    patchShebangs audit.bash
  '';

  outputs = [
    "out"
    "man"
  ];

  build-system = with python3.pkgs; [ setuptools ];
  dependencies = with python3.pkgs; [
    requests
    setuptools
    zxcvbn
  ];

  # Tests freeze on darwin with: pass-audit-1.1 (checkPhase): EOFError
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [
    python3.pkgs.green
    pass
    gnupg
  ];
  checkPhase = ''
    python3 -m green -q
  '';

  postInstall = ''
    mkdir -p $out/lib/password-store/extensions
    install -m777 audit.bash $out/lib/password-store/extensions/audit.bash
    cp -r share $out/
    buildPythonPath "$out $dependencies"
    wrapProgram $out/lib/password-store/extensions/audit.bash \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --run "export COMMAND"
  '';

  pythonImportsCheck = [ "pass_audit" ];

  meta = with lib; {
    description = "Pass extension for auditing your password repository";
    homepage = "https://github.com/roddhjav/pass-audit";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma27 ];
  };
}
