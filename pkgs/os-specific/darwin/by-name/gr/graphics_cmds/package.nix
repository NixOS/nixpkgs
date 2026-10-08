{
  lib,
  atf,
  bashNonInteractive,
  coreutils,
  file,
  gnused,
  kyua,
  libtiff,
  oxipng,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "graphics_cmds";
  version = "1";

  src = ./.;

  dontConfigure = true;

  strictDeps = true;

  buildInputs = [ bashNonInteractive ];

  buildPhase = ''
    runHook preBuild

    mkdir build

    substitute extra-bins/copypng build/copypng \
      --replace-fail '@cp@' ${lib.getExe' coreutils "cp"} \
      --replace-fail '@echo@' ${lib.getExe' coreutils "echo"} \
      --replace-fail '@file@' ${lib.getExe file} \
      --replace-fail '@oxipng@' ${lib.getExe oxipng}

    substitute extra-bins/tiffutil build/tiffutil \
      --replace-fail '@cp@' ${lib.getExe' coreutils "cp"} \
      --replace-fail '@cut@' ${lib.getExe' coreutils "cut"} \
      --replace-fail '@echo@' ${lib.getExe' coreutils "echo"} \
      --replace-fail '@tail@' ${lib.getExe' coreutils "tail"} \
      --replace-fail '@sed@' ${lib.getExe gnused} \
      --replace-fail '@tiffcp@' ${lib.getExe' libtiff "tiffcp"} \
      --replace-fail '@tiffdump@' ${lib.getExe' libtiff "tiffdump"} \
      --replace-fail '@tiffinfo@' ${lib.getExe' libtiff "tiffinfo"} \
      --replace-fail '@tiffset@' ${lib.getExe' libtiff "tiffset"}

    chmod a+x build/*

    patchShebangs --host build

    runHook postBuild
  '';

  doCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;

  nativeCheckInputs = [
    atf
    kyua
    libtiff
  ];

  preCheck = ''
    export PATH=$PWD/build:$PATH
    patchShebangs tests
  '';

  installPhase = ''
    runHook preInstall

    install -m755 -D build/copypng "$out/bin/copypng"
    install -m755 -D build/tiffutil "$out/bin/tiffutil"

    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Mostly compatible replacements for copypng and tiffutil";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    teams = [ lib.teams.darwin ];
  };
}
