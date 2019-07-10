{ stdenv, fetchFromGitHub
, talloc, docutils, swig, python, coreutils, enablePython ? true }:

stdenv.mkDerivation rec {
  pname = "proot";
  version = "5.1.0";

  src = fetchFromGitHub {
    repo = "proot";
    owner = "proot-me";
    rev = "v${version}";
    sha256 = "0azsqis99gxldmbcg43girch85ysg4hwzf0h1b44bmapnsm89fbz";
  };

  postPatch = ''
    substituteInPlace src/GNUmakefile \
      --replace /bin/echo ${coreutils}/bin/echo
    # our cross machinery defines $CC and co just right
    sed -i /CROSS_COMPILE/d src/GNUmakefile
  '';

  buildInputs = [ talloc ] ++ stdenv.lib.optional enablePython python;
  nativeBuildInputs = [ docutils ] ++ stdenv.lib.optional enablePython swig;

  enableParallelBuilding = true;

  makeFlags = [ "-C src" ];

  postBuild = ''
    make -C doc proot/man.1
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -Dm644 doc/proot/man.1 $out/share/man/man1/proot.1
  '';

  meta = with stdenv.lib; {
    homepage = http://proot-me.github.io;
    description = "User-space implementation of chroot, mount --bind and binfmt_misc";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ianwookim makefu veprbl dtzWill ];
  };
}
