{ lib, poetry2nix, python, fetchFromGitHub, runtimeShell }:


poetry2nix.mkPoetryApplication {

  inherit python;

  pyproject = ./pyproject.toml;
  poetrylock = ./poetry.lock;

  src = fetchFromGitHub (lib.importJSON ./src.json);

  # "Vendor" dependencies (for build-system support)
  postPatch = ''
    for path in ''${PYTHONPATH//:/ }; do
      echo "sys.path.insert(0, \"$path\")" >> poetry/__init__.py
    done
  '';

  # Poetry is a bit special in that it can't use itself as the `build-system` property in pyproject.toml.
  # That's why we need to hackily install outputs completely manually.
  #
  # For projects using poetry normally overriding the installPhase is not required.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${python.libPrefix}/site-packages
    cp -r poetry $out/lib/${python.libPrefix}/site-packages

    mkdir -p $out/bin
    cat > $out/bin/poetry <<EOF
    #!${python.interpreter}
    import sys

    if __name__ == '__main__':
        sys.path.append("$out/lib/${python.libPrefix}/site-packages")
        from poetry.console import main
        main()
    EOF
    chmod +x $out/bin/poetry

    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/poetry" completions bash > "$out/share/bash-completion/completions/poetry"
    mkdir -p "$out/share/zsh/vendor-completions"
    "$out/bin/poetry" completions zsh > "$out/share/zsh/vendor-completions/_poetry"
    mkdir -p "$out/share/fish/vendor_completions.d"
    "$out/bin/poetry" completions fish > "$out/share/fish/vendor_completions.d/poetry.fish"

    runHook postInstall
  '';

  # Propagating dependencies leads to issues downstream
  # We've already patched poetry to prefer "vendored" dependencies
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  # Fails because of impurities (network, git etc etc)
  doCheck = false;

  meta = with lib; {
    platforms = platforms.all;
    maintainers = with maintainers; [ adisbladis jakewaksbaum ];
  };
}
