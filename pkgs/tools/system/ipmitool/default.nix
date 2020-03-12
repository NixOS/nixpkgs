{ stdenv, lib, fetchurl, openssl, fetchpatch, static ? false }:

let
  pkgname = "ipmitool";
  version = "1.8.18";
in
stdenv.mkDerivation {
  name = "${pkgname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pkgname}/${pkgname}-${version}.tar.gz";
    sha256 = "0kfh8ny35rvwxwah4yv91a05qwpx74b5slq2lhrh71wz572va93m";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/i/ipmitool/1.8.18-6/debian/patches/0120-openssl1.1.patch";
      sha256 = "1xvsjxb782lzy72bnqqnsk3r5h4zl3na95s4pqn2qg7cic2mnbfk";
    })
    # Fix build on non-linux systems
    (fetchpatch {
      url = "https://github.com/ipmitool/ipmitool/commit/5db314f694f75c575cd7c9ffe9ee57aaf3a88866.patch";
      sha256 = "01niwrgajhrdhl441gzmw6v1r1yc3i8kn98db4b6smfn5fwdp1pa";
    })
  ];

  buildInputs = [ openssl ];

  configureFlags = [
    "--infodir=${placeholder "out"}/share/info"
    "--mandir=${placeholder "out"}/share/man"
  ] ++ stdenv.lib.optionals static [
    "LDFLAGS=-static"
    "--enable-static"
    "--disable-shared"
  ] ++ stdenv.lib.optionals (!static) [
    "--enable-shared"
  ];

  makeFlags = stdenv.lib.optional static "AM_LDFLAGS=-all-static";
  dontDisableStatic = static;

  meta = with lib; {
    description = ''Command-line interface to IPMI-enabled devices'';
    license = licenses.bsd3;
    homepage = https://sourceforge.net/projects/ipmitool/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
