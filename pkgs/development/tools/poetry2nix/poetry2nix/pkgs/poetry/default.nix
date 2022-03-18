{ lib
, poetry2nix
, python
, fetchFromGitHub
, projectDir ? ./.
, pyproject ? projectDir + "/pyproject.toml"
, poetrylock ? projectDir + "/poetry.lock"
, installShellFiles
}:


poetry2nix.mkPoetryApplication {

  inherit python;

  inherit projectDir pyproject poetrylock;

  # Don't include poetry in inputs
  __isBootstrap = true;

  src = fetchFromGitHub (lib.importJSON ./src.json);

  # "Vendor" dependencies (for build-system support)
  postPatch = ''
    echo "import sys" >> poetry/__init__.py
    for path in $propagatedBuildInputs; do
        echo "sys.path.insert(0, \"$path\")" >> poetry/__init__.py
    done
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    # Figure out the location of poetry.core
    # As poetry.core is using the same root import name as the poetry package and the python module system wont look for the root
    # in the separate second location we need to link poetry.core to poetry
    ln -s $(python -c 'import poetry.core; import os.path; print(os.path.dirname(poetry.core.__file__))') $out/${python.sitePackages}/poetry/core

    # Completions
    installShellCompletion --cmd poetry \
      --bash <($out/bin/poetry completions bash) \
      --fish <($out/bin/poetry completions fish) \
      --zsh <($out/bin/poetry completions zsh) \
  '';

  # Propagating dependencies leads to issues downstream
  # We've already patched poetry to prefer "vendored" dependencies
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  # Fails because of impurities (network, git etc etc)
  doCheck = false;

  meta = with lib; {
    inherit (python.meta) platforms;
    maintainers = with maintainers; [ adisbladis jakewaksbaum ];
  };
}
