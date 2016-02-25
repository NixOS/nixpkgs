{ stdenv, fetchgit, talloc, docutils
, enableStatic ? false }:

stdenv.mkDerivation rec {
  name = "proot-${version}";
  version = "4.0.3";

  src = fetchgit {
    url = "git://github.com/cedric-vincent/proot.git";
    rev = "refs/tags/v${version}";
    sha256 = "95a52b2fa47b2891eb2c6b6b0e14d42f6d48f6fd5181e359b007831f1a046e84";
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
    maintainers = [ maintainers.ianwookim ];
  };
}

