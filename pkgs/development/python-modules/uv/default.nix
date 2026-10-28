{
  buildPythonPackage,
  hatchling,
  lib,
  uv,
}:

buildPythonPackage {
  inherit (uv)
    pname
    version
    src
    meta
    ;
  pyproject = true;

  build-system = [ hatchling ];

  postPatch =
    # Add the path to the uv binary as a fallback after other path search methods have been exhausted
    ''
      substituteInPlace python/uv/_find_uv.py \
        --replace-fail \
        'sysconfig.get_path("scripts", scheme=_user_scheme()),' \
        'sysconfig.get_path("scripts", scheme=_user_scheme()), "${baseNameOf (lib.getExe uv)}",'
    ''
    # Sidestep the maturin build system in favour of reusing the binary already built by nixpkgs,
    # to avoid rebuilding the uv binary for every active python package set.
    + ''
      substituteInPlace pyproject.toml \
        --replace-fail 'requires = ["maturin>=1.0,<2.0"]' 'requires = ["hatchling"]' \
        --replace-fail 'build-backend = "maturin"' 'build-backend = "hatchling.build"'

      cat >> pyproject.toml <<EOF
      [tool.hatch.build]
      packages = ['python/uv']

      EOF
    '';

  postInstall = ''
    mkdir -p $out/bin && ln -s ${lib.getExe uv} $out/bin/uv
  '';

  pythonImportsCheck = [ "uv" ];
}
