{ stdenv, fetchFromGitHub, meson, pkgconfig, ninja, glib, fuse3
, buildManPages ? true, docutils
}:

let
  inherit (stdenv.lib) optional;
  rpath = stdenv.lib.makeLibraryPath [ fuse3 glib ];
in stdenv.mkDerivation rec {
  version = "3.3.0";
  name = "sshfs-fuse-${version}";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "sshfs";
    rev = "sshfs-${version}";
    sha256 = "1hn5c0059ppjqygdhvapxm7lrqm5bnpwaxgjylskz04c0vr8nygp";
  };

  patches = optional buildManPages ./build-man-pages.patch;

  nativeBuildInputs = [ meson pkgconfig ninja ];
  buildInputs = [ fuse3 glib ] ++ optional buildManPages docutils;

  NIX_CFLAGS_COMPILE = stdenv.lib.optional
    (stdenv.system == "i686-linux")
    "-D_FILE_OFFSET_BITS=64";

  postInstall = ''
    mkdir -p $out/sbin
    ln -sf $out/bin/sshfs $out/sbin/mount.sshfs
  '';

  postFixup = ''
       patchelf --set-rpath '${rpath}' "$out/bin/sshfs"
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "FUSE-based filesystem that allows remote filesystems to be mounted over SSH";
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
