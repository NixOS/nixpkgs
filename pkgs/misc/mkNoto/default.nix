{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  python3Packages,
}:

{
  isVariable ? true,
  subsets ? [],
  fontConfig ? "",
  ...
}@args:
let
  pythonEnv = python3Packages.python.withPackages (ps: [ ps.notobuilder ps.pyyaml ]);
in
stdenv.mkDerivation ({
  nativeBuildInputs = [ pythonEnv ];

  buildPhase = ''
    runHook preBuild

    ${lib.getExe pythonEnv} ${./updateConfig.py} sources/config-${fontConfig}.yaml
    ${lib.getExe pythonEnv} -m notobuilder sources/config-${fontConfig}.yaml

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $hinted/share/fonts/truetype fonts/*/hinted/ttf/*
    install -m444 -Dt $otf/share/fonts/opentype fonts/*/unhinted/otf/*
    install -m444 -Dt $ttf/share/fonts/truetype fonts/*/unhinted/ttf/*

    ${ if isVariable then ''
      install -m444 -Dt $slim_variable_ttf/share/fonts/truetype fonts/*/unhinted/slim-variable-ttf/*
      install -m444 -Dt $variable_ttf/share/fonts/truetype fonts/*/unhinted/variable-ttf/*

      mkdir -p $out/share/fonts/truetype
      ln -s $variable_ttf/share/fonts/truetype/* $out/share/fonts/truetype
    '' else ''
      mkdir -p $out/share/fonts/opentype
      ln -s $otf/share/fonts/opentype/* $out/share/fonts/opentype
    ''
    }

    runHook postInstall
  '';

  outputs = [
    "out"
    "hinted"
    "otf"
    "ttf"
  ] ++ lib.optionals isVariable [
    "slim_variable_ttf"
    "variable_ttf"
  ];
} // args)
