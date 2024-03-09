{ lib, stdenv, fetchurl, fetchpatch
, libtool, bison, groff, ghostscript, gettext
, acl, libcap, lsof }:
stdenv.mkDerivation rec {
  pname = "explain";
  version = "1.4";

  src = fetchurl {
    url = "mirror://sourceforge/libexplain/libexplain-${version}.tar.gz";
    hash = "sha256-KIY7ZezMdJNOI3ysQTZMs8GALDbJ4jGO0EF0YP7oP4A=";
  };

  patches = let
    debian-src = "https://sources.debian.org/data/main";
    debian-ver = "${version}.D001-12";
    debian-patch = fname: hash: fetchpatch {
      name = fname;
      url = "${debian-src}/libe/libexplain/${debian-ver}/debian/patches/${fname}";
      hash = hash;
    };
  in [
    (debian-patch "sanitize-bison.patch"
      "sha256-gU6JG32j2yIOwehZTUSvIr4TSDdlg+p1U3bhfZHMEDY=")
    (debian-patch "03_fsflags-4.5.patch"
      "sha256-ML7Qvf85vEBp+iwm6PSosMAn/frYdEOSHRToEggmR8M=")
    (debian-patch "linux5.11.patch"
      "sha256-N7WwnTfwOxBfIiKntcFOqHTH9r2gd7NMEzic7szzR+Y=")
    (debian-patch "termiox-no-more-exists-since-kernel-5.12.patch"
      "sha256-cocgEYKoDMDnGk9VNQDtgoVxMGnnNpdae0hzgUlacOw=")
    (debian-patch "gcc-10.patch"
      "sha256-YNcYGyOOqPUuwpUpXGcR7zsWbepVg8SAqcVKlxENSQk=")
  ];

  nativeBuildInputs = [ libtool bison groff ghostscript gettext ];
  buildInputs = [ acl libcap lsof ];

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  meta = with lib; {
    description = "Library and utility to explain system call errors";
    homepage = "https://libexplain.sourceforge.net";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ McSinyx ];
    platforms = platforms.unix;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
