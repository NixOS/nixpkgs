{ stdenv, fetchgit, talloc }:

stdenv.mkDerivation rec {
  name = "proot-${version}";
  version = "4.0.3";

  src = fetchgit {
    url = "git://github.com/cedric-vincent/proot.git";
    rev = "refs/tags/v${version}";
    sha256 = "95a52b2fa47b2891eb2c6b6b0e14d42f6d48f6fd5181e359b007831f1a046e84";
  };

  buildInputs = [ talloc ];

  preBuild = ''
    substituteInPlace GNUmakefile --replace "/usr/local" "$out"
  '';

  sourceRoot = "proot/src";

  meta = with stdenv.lib; {
    homepage = http://proot.me;
    description = "User-space implementation of chroot, mount --bind and binfmt_misc";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.ianwookim ];
  };
}

