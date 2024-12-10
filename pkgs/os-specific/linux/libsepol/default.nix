{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "libsepol";
  version = "3.6";
  se_url = "https://github.com/SELinuxProject/selinux/releases/download";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "${se_url}/${version}/libsepol-${version}.tar.gz";
    sha256 = "sha256-ydxYXqlJA9eE1ZfIYc1dzmRZFo+V4isxoOqxzdgAl1o=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isStatic ''
    substituteInPlace src/Makefile --replace 'all: $(LIBA) $(LIBSO)' 'all: $(LIBA)'
    sed -i $'/^\t.*LIBSO/d' src/Makefile
  '';

  nativeBuildInputs = [ flex ];

  makeFlags = [
    "PREFIX=$(out)"
    "BINDIR=$(bin)/bin"
    "INCDIR=$(dev)/include/sepol"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN8DIR=$(man)/share/man/man8"
    "SHLIBDIR=$(out)/lib"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  enableParallelBuilding = true;

  passthru = { inherit se_url; };

  meta = with lib; {
    description = "SELinux binary policy manipulation library";
    homepage = "http://userspace.selinuxproject.org";
    platforms = platforms.linux;
    maintainers = with maintainers; [ RossComputerGuy ];
    license = lib.licenses.gpl2Plus;
    pkgConfigModules = [ "libselinux" ];
  };
}
