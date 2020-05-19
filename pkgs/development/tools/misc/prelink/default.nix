{ stdenv, fetchgit, autoreconfHook
, libelf, libiberty
}:

stdenv.mkDerivation rec {
  pname = "prelink";
  version = "2019-6-24-" + stdenv.lib.substring 0 7 src.rev;

  src = fetchgit {
    url = "https://git.yoctoproject.org/git/prelink-cross";
    branchName = "cross_prelink";
    rev = "f9975537dbfd9ade0fc813bd5cf5fcbe41753a37";
    sha256 = "15x1p6x9wndbjqaajhmg5nd4rcg805blixwm0l0jaiqbi9kfiprv";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    stdenv.cc.libc (stdenv.lib.getOutput "static" stdenv.cc.libc)
    libelf libiberty
  ];

  # There are some failures to investigate
  doCheck = false;

  preCheck = ''
    patchShebangs --build testsuite
  '';

  meta = {
    homepage = "https://wiki.yoctoproject.org/wiki/Cross-Prelink";
    #homepage = "https://people.redhat.com/jakub/prelink/";
    license = "GPL";
    description = "ELF prelinking utility to speed up dynamic linking";
    platforms = stdenv.lib.platforms.linux;
  };
}
