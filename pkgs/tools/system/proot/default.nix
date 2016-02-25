{ stdenv, fetchFromGitHub, talloc, docutils
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

  buildInputs = [ talloc ];
  nativeBuildInputs = [ docutils ];

  enableParallelBuilding = true;

  preBuild = stdenv.lib.optionalString enableStatic ''
    export LDFLAGS="-static -L${talloc}/lib"
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
    homepage = http://proot.me;
    description = "User-space implementation of chroot, mount --bind and binfmt_misc";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ianwookim nckx ];
  };
}

