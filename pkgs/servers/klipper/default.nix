{ stdenv
, lib
, fetchFromGitHub
, python2
, unstableGitUpdater
}:
stdenv.mkDerivation rec {
  pname = "klipper";
  version = "unstable-2021-11-10";

  src = fetchFromGitHub {
    owner = "KevinOConnor";
    repo = "klipper";
    rev = "c179db3d4331db9d85c7acfdaa1e96e295d277ba";
    sha256 = "sha256-/fFbhKiSQq9E9iucinTgUTyOtfDKCMgvzebHjfOaJ+M=";
  };

  sourceRoot = "source/klippy";

  # there is currently an attempt at moving it to Python 3, but it will remain
  # Python 2 for the foreseeable future.
  # c.f. https://github.com/KevinOConnor/klipper/pull/3278
  # NB: This is needed for the postBuild step
  nativeBuildInputs = [ (python2.withPackages ( p: with p; [ cffi ] )) ];

  buildInputs = [ (python2.withPackages (p: with p; [ cffi pyserial greenlet jinja2 ])) ];

  # we need to run this to prebuild the chelper.
  postBuild = "python2 ./chelper/__init__.py";

  # NB: We don't move the main entry point into `/bin`, or even symlink it,
  # because it uses relative paths to find necessary modules. We could wrap but
  # this is used 99% of the time as a service, so it's not worth the effort.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/klipper
    cp -r ./* $out/lib/klipper

    chmod 755 $out/lib/klipper/klippy.py
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { url = meta.homepage; };

  meta = with lib; {
    description = "The Klipper 3D printer firmware";
    homepage = "https://github.com/KevinOConnor/klipper";
    maintainers = with maintainers; [ lovesegfault zhaofengli ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}
