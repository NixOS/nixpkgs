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
