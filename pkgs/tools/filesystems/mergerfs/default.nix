{ stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, gettext, libtool, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  pname = "mergerfs";
  version = "2.28.1";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = version;
    sha256 = "18yc80ccpqf785gah5xw6jg5524wfra8bf3pcjr7idzdz4ca7nvf";
  };

  nativeBuildInputs = [
    automake autoconf pkgconfig gettext libtool pandoc which
  ];
  buildInputs = [ attr libiconv ];

  preConfigure = ''
    echo "${version}" > VERSION
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" "XATTR_AVAILABLE=1" ];
  enableParallelBuilding = true;

  postFixup = ''
    ln -srf $out/bin/mergerfs $out/bin/mount.fuse.mergerfs
    ln -srf $out/bin/mergerfs $out/bin/mount.mergerfs
  '';

  meta = {
    description = "A FUSE based union filesystem";
    homepage = "https://github.com/trapexit/mergerfs";
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jfrankenau makefu ];
  };
}
