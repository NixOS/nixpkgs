{ lib, poetry2nix, python, fetchFromGitHub }:


poetry2nix.mkPoetryApplication {

  inherit python;

  projectDir = ./.;

  # Don't include poetry in inputs
  __isBootstrap = true;

  src = fetchFromGitHub (lib.importJSON ./src.json);

  # "Vendor" dependencies (for build-system support)
  postPatch = ''
    for path in ''${PYTHONPATH//:/ }; do echo $path; done | uniq | while read path; do
      echo "sys.path.insert(0, \"$path\")" >> poetry/__init__.py
    done
  '';

  postInstall = ''
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
