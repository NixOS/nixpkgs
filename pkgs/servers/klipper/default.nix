{ stdenv
, lib
, fetchFromGitHub
, python3
, unstableGitUpdater
<<<<<<< HEAD
, makeWrapper
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "klipper";
<<<<<<< HEAD
  version = "unstable-2023-09-10";
=======
  version = "unstable-2023-04-24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "KevinOConnor";
    repo = "klipper";
<<<<<<< HEAD
    rev = "8ef0f7d7e3d3b2ac7bc1e80ed3295ceca6bba4e7";
    sha256 = "sha256-f/fPnZvtnASphYtvM9NBae0on8GWSwQPykukZ3XCy3M=";
  };

  sourceRoot = "${src.name}/klippy";

  # NB: This is needed for the postBuild step
  nativeBuildInputs = [
    (python3.withPackages ( p: with p; [ cffi ] ))
    makeWrapper
  ];

  buildInputs = [ (python3.withPackages (p: with p; [ can cffi pyserial greenlet jinja2 markupsafe numpy ])) ];
=======
    rev = "b17ae55f5bd3a079ab3626b1e6fd5c60416e6ba0";
    sha256 = "sha256-e1luOJdTeSB/UNl/W91tBuuQ5f2fKfo1CSMQiE+A1T4=";
  };

  sourceRoot = "source/klippy";

  # NB: This is needed for the postBuild step
  nativeBuildInputs = [ (python3.withPackages ( p: with p; [ cffi ] )) ];

  buildInputs = [ (python3.withPackages (p: with p; [ cffi pyserial greenlet jinja2 markupsafe numpy ])) ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD

    # needed for cross compilation
    substituteInPlace ./chelper/__init__.py \
      --replace 'GCC_CMD = "gcc"' 'GCC_CMD = "${stdenv.cc.targetPrefix}cc"'
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
    mkdir -p $out/bin
    chmod 755 $out/lib/klipper/klippy.py
    makeWrapper $out/lib/klipper/klippy.py $out/bin/klippy --chdir $out/lib/klipper
=======
    chmod 755 $out/lib/klipper/klippy.py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
