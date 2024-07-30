{ lib, stdenv, fetchFromGitHub
, talloc
, pkg-config
, ncurses
, docutils, swig, python3, coreutils, enablePython ? true }:

stdenv.mkDerivation rec {
  pname = "proot";
  version = "5.4.0";

  src = fetchFromGitHub {
    repo = "proot";
    owner = "proot-me";
    rev = "v${version}";
    sha256 = "sha256-Z9Y7ccWp5KEVuo9xfHcgo58XqYVdFo7ck1jH7cnT2KA=";
  };

  postPatch = ''
    substituteInPlace src/GNUmakefile \
      --replace /bin/echo ${coreutils}/bin/echo
    # our cross machinery defines $CC and co just right
    sed -i /CROSS_COMPILE/d src/GNUmakefile
  '';

  buildInputs = [ ncurses talloc ] ++ lib.optional enablePython python3;
  nativeBuildInputs = [ pkg-config docutils ] ++ lib.optional enablePython swig;

  enableParallelBuilding = true;

  makeFlags = [ "-C src" ];

  postBuild = ''
    make -C doc proot/man.1
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -Dm644 doc/proot/man.1 $out/share/man/man1/proot.1
  '';

  # proot provides tests with `make -C test` however they do not run in the sandbox
  doCheck = false;

  meta = with lib; {
    homepage = "https://proot-me.github.io";
    description = "User-space implementation of chroot, mount --bind and binfmt_misc";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ianwookim makefu veprbl ];
    mainProgram = "proot";
  };
}
