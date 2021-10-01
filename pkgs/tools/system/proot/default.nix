{ lib, stdenv, fetchFromGitHub, fetchpatch
, talloc
, pkg-config
, libarchive
, git
, ncurses
, docutils, swig, python3, coreutils, enablePython ? true }:

stdenv.mkDerivation rec {
  pname = "proot";
  version = "5.2.0";

  src = fetchFromGitHub {
    repo = "proot";
    owner = "proot-me";
    rev = "v${version}";
    sha256 = "1ir3a7rp9rvpv9i8gjrkr383sqadgl7f9nflcrfg7q05bxapwiws";
  };

  postPatch = ''
    substituteInPlace src/GNUmakefile \
      --replace /bin/echo ${coreutils}/bin/echo
    # our cross machinery defines $CC and co just right
    sed -i /CROSS_COMPILE/d src/GNUmakefile
  '';

  buildInputs = [ ncurses libarchive talloc ] ++ lib.optional enablePython python3;
  nativeBuildInputs = [ pkg-config docutils ] ++ lib.optional enablePython swig;
  patches = [
    # without this patch the package does not build with python>3.7
    (fetchpatch {
      url = "https://github.com/proot-me/proot/pull/285.patch";
      sha256= "1vncq36pr4v0h63fijga6zrwlsb0vb4pj25zxf1ni15ndxv63pxj";
    })
  ];

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
    license = licenses.gpl2;
    maintainers = with maintainers; [ ianwookim makefu veprbl dtzWill ];
  };
}
