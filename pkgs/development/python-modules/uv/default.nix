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
    # Do not rely on path lookup at runtime to find the uv binary.
    # Use the propagated binary instead.
    ''
      substituteInPlace python/uv/_find_uv.py \
        --replace-fail '"""Return the uv binary path."""' "return '${lib.getExe uv}'"
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
