{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
  extraPythonPackages ? ps: [ ],
  unstableGitUpdater,
  makeWrapper,
  writeShellScript,
}:
let
  isCross = (stdenv.hostPlatform != stdenv.buildPlatform);
in
stdenv.mkDerivation rec {
  pname = "klipper";
  version = "0.13.0-unstable-2026-03-21";

  src = fetchFromGitHub {
    owner = "KevinOConnor";
    repo = "klipper";
    rev = "594ec7e1205450ff0753d19f0724bbe8b380465d";
    sha256 = "sha256-a496Ayas2IsP3K320EXc/7VDAtrqUzF8OaKNKBWf8lQ=";
  };

  sourceRoot = "${src.name}/klippy";

  # NB: This is needed for the postBuild step
  nativeBuildInputs = [
    python3Packages.cffi
    makeWrapper
  ];

  buildInputs = [
    (python3.withPackages (
      p:
      with p;
      [
        python-can
        cffi
        pyserial
        greenlet
        jinja2
        markupsafe
        numpy
      ]
      ++ extraPythonPackages p
    ))
  ];

  # we need to run this to prebuild the chelper .so. However when cross
  # compiling, a patch is temporarily required during the build process to
  # prevent the build process from using dlopen() on this .so which has been
  # built for a foreign architecture. We then place the unpatched __init__.py
  # back, as this dlopen() call is required at runtime
  postBuild =
    if isCross then
      ''
        python ./chelper/__init__.py
        mv ./chelper/__init__unpatched.py ./chelper/__init__.py
      ''
    else
      ''
        python ./chelper/__init__.py
      '';

  prePatch = lib.optionalString isCross ''
    cp ./chelper/__init__.py ./chelper/__init__unpatched.py
  '';

  patches = lib.optionals isCross [
    # https://github.com/Klipper3d/klipper/pull/7254
    ./cross-ffi.patch
  ];

  # Python 3 is already supported but shebangs aren't updated yet
  postPatch = ''
    for file in klippy.py console.py parsedump.py; do
      substituteInPlace $file \
        --replace '/usr/bin/env python2' '/usr/bin/env python'
    done

    # needed for cross compilation
    substituteInPlace ./chelper/__init__*.py \
      --replace 'GCC_CMD = "gcc"' 'GCC_CMD = "${stdenv.cc.targetPrefix}cc"'
  '';

  pythonInterpreter =
    (python3.withPackages (
      p: with p; [
        numpy
        matplotlib
      ]
    )).interpreter;

  pythonScriptWrapper = writeShellScript pname ''
    ${pythonInterpreter} "@out@/lib/scripts/@script@" "$@"
  '';

  # NB: We don't move the main entry point into `/bin`, or even symlink it,
  # because it uses relative paths to find necessary modules. We could wrap but
  # this is used 99% of the time as a service, so it's not worth the effort.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/klipper
    cp -r ./* $out/lib/klipper

    # Moonraker expects `config_examples` and `docs` to be available
    # under `klipper_path`
    cp -r $src/docs $out/lib/docs
    cp -r $src/config $out/lib/config
    cp -r $src/scripts $out/lib/scripts
    cp -r $src/klippy $out/lib/klippy

    # Add version information. For the normal procedure see https://www.klipper3d.org/Packaging.html#versioning
    # This is done like this because scripts/make_version.py is not available when sourceRoot is set to "${src.name}/klippy"
    echo "${version}-NixOS" > $out/lib/klipper/.version

    mkdir -p $out/bin
    chmod 755 $out/lib/klipper/klippy.py
    makeWrapper $out/lib/klipper/klippy.py $out/bin/klippy --chdir $out/lib/klipper

    substitute "$pythonScriptWrapper" "$out/bin/klipper-calibrate-shaper" \
      --subst-var "out" \
      --subst-var-by "script" "calibrate_shaper.py"
    chmod 755 "$out/bin/klipper-calibrate-shaper"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    url = meta.homepage;
    tagPrefix = "v";
  };

  meta = {
    description = "Klipper 3D printer firmware";
    mainProgram = "klippy";
    homepage = "https://github.com/KevinOConnor/klipper";
    maintainers = with lib.maintainers; [
      lovesegfault
      zhaofengli
      cab404
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
}
