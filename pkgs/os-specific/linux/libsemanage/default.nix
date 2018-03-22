{ stdenv, fetchurl, bison, flex, libsepol, libselinux, ustr, bzip2, libaudit }:

stdenv.mkDerivation rec {
  name = "libsemanage-${version}";
  version = "2.4";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libsemanage-${version}.tar.gz";
    sha256 = "1134ka4mi4387ac5yv68bpp2y7ln5xxhwp07xhqnay0nxzjaqk0s";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libsepol libselinux ustr bzip2 libaudit ];

  NIX_CFLAGS_COMPILE = [
    "-fstack-protector-all"
    "-std=gnu89"
    # these were added to fix build with gcc7. review on update
    "-Wno-error=format-truncation"
    "-Wno-error=implicit-fallthrough"
  ];

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
  '';

  meta = libsepol.meta // {
    description = "Policy management tools for SELinux";
    license = stdenv.lib.licenses.lgpl21;
  };
}
