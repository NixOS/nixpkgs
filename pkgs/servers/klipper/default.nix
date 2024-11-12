{ stdenv
, lib
, fetchFromGitHub
, python3
, unstableGitUpdater
, makeWrapper
, writeShellScript
}:

stdenv.mkDerivation rec {
  pname = "klipper";
  version = "0.12.0-unstable-2024-10-26";

  src = fetchFromGitHub {
    owner = "KevinOConnor";
    repo = "klipper";
    rev = "31fe50ffa387ed4a45950c1043a3b214a9d554dd";
    sha256 = "sha256-szGAQ5ttT1Y0q3pf6m9xNHreNjdmdWU8k0hwcT/6MDA=";
  };

  sourceRoot = "${src.name}/klippy";

  # NB: This is needed for the postBuild step
  nativeBuildInputs = [
    (python3.withPackages ( p: with p; [ cffi ] ))
    makeWrapper
  ];

  buildInputs = [ (python3.withPackages (p: with p; [ python-can cffi pyserial greenlet jinja2 markupsafe numpy ])) ];

  # we need to run this to prebuild the chelper.
  postBuild = ''
    python ./chelper/__init__.py
  '';

  # Python 3 is already supported but shebangs aren't updated yet
  postPatch = ''
    for file in klippy.py console.py parsedump.py; do
      substituteInPlace $file \
        --replace '/usr/bin/env python2' '/usr/bin/env python'
    done

    # needed for cross compilation
    substituteInPlace ./chelper/__init__.py \
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

  meta = with lib; {
    description = "Klipper 3D printer firmware";
    mainProgram = "klippy";
    homepage = "https://github.com/KevinOConnor/klipper";
    maintainers = with maintainers; [ lovesegfault zhaofengli cab404 ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}
