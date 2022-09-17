{ stdenv
, lib
, fetchFromGitHub
, python3
, unstableGitUpdater
}:
stdenv.mkDerivation rec {
  pname = "klipper";
  version = "unstable-2022-09-11";

  src = fetchFromGitHub {
    owner = "KevinOConnor";
    repo = "klipper";
    rev = "ee5bdbadd1d00cf161e0b2cdfbcf5c622abc8326";
    sha256 = "sha256-nVnJQEi6xNMNpC5byG1ce3M5hpJOd53g1ugjHXKY2zI=";
  };

  sourceRoot = "source/klippy";

  # NB: This is needed for the postBuild step
  nativeBuildInputs = [ (python3.withPackages ( p: with p; [ cffi ] )) ];

  buildInputs = [ (python3.withPackages (p: with p; [ cffi pyserial greenlet jinja2 markupsafe ])) ];

  # we need to run this to prebuild the chelper.
  postBuild = "python ./chelper/__init__.py";

  # 2022-06-28: Python 3 is already supported in klipper, alas shebangs remained
  # the same - we replace them in patchPhase.
  patchPhase = ''
    for F in klippy.py console.py parsedump.py; do
      substituteInPlace $F \
        --replace '/usr/bin/env python2' '/usr/bin/env python'
    done
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

    chmod 755 $out/lib/klipper/klippy.py
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { url = meta.homepage; };

  meta = with lib; {
    description = "The Klipper 3D printer firmware";
    homepage = "https://github.com/KevinOConnor/klipper";
    maintainers = with maintainers; [ lovesegfault zhaofengli cab404 ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}
