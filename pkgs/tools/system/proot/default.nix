{ stdenv, fetchFromGitHub, fetchpatch
, talloc, docutils
, enableStatic ? false }:

stdenv.mkDerivation rec {
  name = "proot-${version}";
  version = "5.1.0";

  src = fetchFromGitHub {
    sha256 = "0azsqis99gxldmbcg43girch85ysg4hwzf0h1b44bmapnsm89fbz";
    rev = "v${version}";
    repo = "proot";
    owner = "cedric-vincent";
  };

  buildInputs = [ talloc ] ++ stdenv.lib.optional enableStatic stdenv.cc.libc.static;
  nativeBuildInputs = [ docutils ];

  enableParallelBuilding = true;

  patches = [
    (fetchpatch { # debian patch for aarch64 build
      sha256 = "18milpzjkbfy5ab789ia3m4pyjyr9mfzbw6kbjhkj4vx9jc39svv";
      url = "https://sources.debian.net/data/main/p/proot/5.1.0-1.2/debian/patches/arm64.patch";
    })
  ];

  preBuild = stdenv.lib.optionalString enableStatic ''
    export LDFLAGS="-static"
  '';

  makeFlags = [ "-C src" ];

  postBuild = ''
    make -C doc proot/man.1
  '';

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    install -Dm644 doc/proot/man.1 $out/share/man/man1/proot.1
  '';

  meta = with stdenv.lib; {
    homepage = http://proot-me.github.io;
    description = "User-space implementation of chroot, mount --bind and binfmt_misc";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ianwookim nckx makefu ];
  };
}
