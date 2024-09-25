{ stdenv
, lib
, fetchFromGitHub
, python3
, unstableGitUpdater
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "klipper";
  version = "0.12.0-unstable-2024-09-01";

  src = fetchFromGitHub {
    owner = "KevinOConnor";
    repo = "klipper";
    rev = "08a1c9f12760ee6d89db2b82e76c7d93453212db";
    sha256 = "sha256-bVHSiWqswum4ykVpPTt11wJSGnSjJnMT8OUvbYGFopY=";
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

    # Add version information. For the normal procedure see https://www.klipper3d.org/Packaging.html#versioning
    # This is done like this because scripts/make_version.py is not available when sourceRoot is set to "${src.name}/klippy"
    echo "${version}-NixOS" > $out/lib/klipper/.version

    mkdir -p $out/bin
    chmod 755 $out/lib/klipper/klippy.py
    makeWrapper $out/lib/klipper/klippy.py $out/bin/klippy --chdir $out/lib/klipper
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
