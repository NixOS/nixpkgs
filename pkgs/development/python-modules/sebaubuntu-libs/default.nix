{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  android-image-kitchen,
  gitpython,
  poetry-core,
  pyelftools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "sebaubuntu-libs";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sebaubuntu-python";
    repo = "sebaubuntu_libs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LV7Me+GmgOvDh0XGoLaftCKtP/fnB5xVqb8nArOMIys=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    gitpython
    pyelftools
    requests
  ];

  postPatch = ''
    # Patch libaik to use AIK from nixpkgs
    substituteInPlace sebaubuntu_libs/libaik/__init__.py \
      --replace-fail \
        "Repo.clone_from(AIK_REPO, self.path)" "" \
      --replace-fail \
        "unpackimg.sh" "${lib.getExe' android-image-kitchen "aik-unpackimg"}" \
      --replace-fail \
        "repack.sh" "${lib.getExe' android-image-kitchen "aik-repackimg"}" \
      --replace-fail \
        "cleanup.sh" "${lib.getExe' android-image-kitchen "aik-cleanup"}" \
      --replace-fail \
        'command = [self.path / script, "--nosudo", *args]' \
        'command = [script, "--nosudo", *args]' \
      --replace-fail \
        'return check_output(command, stderr=STDOUT, universal_newlines=True, encoding="utf-8")' \
        'return check_output(command, stderr=STDOUT, universal_newlines=True, encoding="utf-8",
          cwd=self.path)'
  '';

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sebaubuntu_libs" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SebaUbuntu's shared libs";
    homepage = "https://github.com/sebaubuntu-python/sebaubuntu_libs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
