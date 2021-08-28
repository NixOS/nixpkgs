{ lib, poetry2nix, python, fetchFromGitHub }:


poetry2nix.mkPoetryApplication {

  inherit python;

  projectDir = ./.;

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

  postInstall = ''
    # Figure out the location of poetry.core
    # As poetry.core is using the same root import name as the poetry package and the python module system wont look for the root
    # in the separate second location we need to link poetry.core to poetry
    ln -s $(python -c 'import poetry.core; import os.path; print(os.path.dirname(poetry.core.__file__))') $out/${python.sitePackages}/poetry/core

    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/poetry" completions bash > "$out/share/bash-completion/completions/poetry"
    mkdir -p "$out/share/zsh/vendor-completions"
    "$out/bin/poetry" completions zsh > "$out/share/zsh/vendor-completions/_poetry"
    mkdir -p "$out/share/fish/vendor_completions.d"
    "$out/bin/poetry" completions fish > "$out/share/fish/vendor_completions.d/poetry.fish"
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
