{
  lib,
  stdenv,
  toPythonModule,
  python,
  pkgs,
  gz-math,
}:

let
  sdformat = pkgs.sdformat.override { python3Packages = python.pkgs; };
in
toPythonModule (
  stdenv.mkDerivation {
    pname = "sdformat";
    inherit (sdformat) version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    propagatedBuildInputs = [ gz-math ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/${python.sitePackages}"
      cp -r ${sdformat}/lib/python/. "$out/${python.sitePackages}/"
      runHook postInstall
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ python ];
    installCheckPhase = ''
      runHook preInstallCheck
      PYTHONPATH="$out/${python.sitePackages}:${gz-math}/${python.sitePackages}''${PYTHONPATH:+:$PYTHONPATH}" \
        ${python.pythonOnBuildForHost.interpreter} -c "import sdformat"
      runHook postInstallCheck
    '';

    meta = sdformat.meta // {
      description = "Python bindings for sdformat";
    };
  }
)
