{ lib, stdenv, fetchFromGitHub
, talloc, docutils, swig, python, coreutils, enablePython ? true }:

stdenv.mkDerivation {
  pname = "proot";
  version = "20190510";

  src = fetchFromGitHub {
    repo = "proot";
    owner = "proot-me";
    rev = "803e54d8a1b3d513108d3fc413ba6f7c80220b74";
    sha256 = "0gwzqm5wpscj3fchlv3qggf3zzn0v00s4crb5ciwljan1zrqadhy";
  };

  postPatch = ''
    substituteInPlace src/GNUmakefile \
      --replace /bin/echo ${coreutils}/bin/echo
    # our cross machinery defines $CC and co just right
    sed -i /CROSS_COMPILE/d src/GNUmakefile
  '';

  buildInputs = [ talloc ] ++ lib.optional enablePython python;
  nativeBuildInputs = [ docutils ] ++ lib.optional enablePython swig;

  enableParallelBuilding = true;

  makeFlags = [ "-C src" ];

  postBuild = ''
    make -C doc proot/man.1
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -Dm644 doc/proot/man.1 $out/share/man/man1/proot.1
  '';

  meta = with lib; {
    homepage = "https://proot-me.github.io";
    description = "User-space implementation of chroot, mount --bind and binfmt_misc";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ianwookim makefu veprbl dtzWill ];
  };
}
