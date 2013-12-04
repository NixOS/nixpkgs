{ stdenv, fetchurl, libsepol, libselinux, ustr, bzip2, bison, flex, audit }:
stdenv.mkDerivation rec {

  name = "libsemanage-${version}";
  version = "2.2";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libsemanage-${version}.tar.gz";
    sha256 = "0xdx0dwcsyw4kv9l6xwdkfg6v7fc9b5y176rkg6n6q0w1zx0pxhi";
  };

  makeFlags = "PREFIX=$(out) DESTDIR=$(out)";

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";
  NIX_CFLAGS_LINK = "-lsepol";

  buildInputs = [ libsepol libselinux ustr bzip2 bison flex audit ];

  meta = with stdenv.lib; {
    inherit (libsepol.meta) homepage platforms maintainers;
    description = "Policy management tools for SELinux";
    license = licenses.lgpl21;
  };
}
