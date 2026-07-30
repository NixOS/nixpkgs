{
  buildPythonPackage,
  hatchling,
  lib,
  ty,
}:

buildPythonPackage {
  inherit (ty)
    pname
    version
    src
    meta
    ;
  pyproject = true;

  build-system = [ hatchling ];

  postPatch =
    # Add the path to the ty binary as a fallback after other path search methods have been exhausted
    ''
      substituteInPlace python/ty/_find_ty.py \
        --replace-fail \
        'sysconfig.get_path("scripts", scheme=_user_scheme()),' \
        'sysconfig.get_path("scripts", scheme=_user_scheme()), "${baseNameOf (lib.getExe ty)}",'
    ''
    # Sidestep the maturin build system in favour of reusing the binary already built by nixpkgs,
    # to avoid rebuilding the ty binary for every active python package set.
    + ''
      substituteInPlace pyproject.toml \
        --replace-fail 'requires = ["maturin>=1.0,<2.0"]' 'requires = ["hatchling"]' \
        --replace-fail 'build-backend = "maturin"' 'build-backend = "hatchling.build"'

      cat >> pyproject.toml <<EOF
      [tool.hatch.build]
      packages = ['python/ty']

      EOF
    '';

  postInstall = ''
    mkdir -p $out/bin && ln -s ${lib.getExe ty} $out/bin/ty
  '';

  pythonImportsCheck = [ "ty" ];
}
