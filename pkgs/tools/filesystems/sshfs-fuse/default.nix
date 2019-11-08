{ stdenv, fetchFromGitHub, fetchpatch, meson, pkgconfig, ninja, docutils, makeWrapper
, fuse3, glib
, which, python3Packages
, openssh
}:

stdenv.mkDerivation rec {
  version = "3.6.0";
  pname = "sshfs-fuse";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    rev = "sshfs-${version}";
    sha256 = "0l4a6azsp920fhl4safxjam6821b77zxhw8mjgm33f60pksslww0";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/libfuse/sshfs/commit/a548abd1f33a8423bec72724a5f48eb96fa55dd2.patch";
    sha256 = "19p94aw7nvydd7p2bd1f5cqhlhhamjhda31k22sg06xaqyl893jm";
  }) ];

  nativeBuildInputs = [ meson pkgconfig ninja docutils makeWrapper ];
  buildInputs = [ fuse3 glib ];
  checkInputs = [ which python3Packages.pytest ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optional
    (stdenv.hostPlatform.system == "i686-linux")
    "-D_FILE_OFFSET_BITS=64";

  postInstall = ''
    mkdir -p $out/sbin
    ln -sf $out/bin/sshfs $out/sbin/mount.sshfs
    wrapProgram $out/bin/sshfs --prefix PATH : "${openssh}/bin"
  '';

  #doCheck = true;
  checkPhase = ''
    # The tests need fusermount:
    mkdir bin && cp ${fuse3}/bin/fusermount3 bin/fusermount
    export PATH=bin:$PATH
    # Can't access /dev/fuse within the sandbox: "FUSE kernel module does not seem to be loaded"
    substituteInPlace test/util.py --replace "/dev/fuse" "/dev/null"
    # TODO: "fusermount executable not setuid, and we are not root"
    # We should probably use a VM test instead
    python3 -m pytest test/
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ primeos ];
  };
}
