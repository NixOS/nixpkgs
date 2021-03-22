{ lib, stdenv, fetchurl, perl, libunwind, buildPackages }:

# libunwind does not have the supportsHost attribute on darwin, thus
# when this package is evaluated it causes an evaluation error
assert stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = "strace";
  version = "5.11";

  src = fetchurl {
    url = "https://strace.io/files/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-/+NAsQwUWg+Fc0Jx6czlZFfSPyGn6lkxqzL4z055OHk=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  buildInputs = [ perl.out ] ++ lib.optional libunwind.supportsHost libunwind; # support -k

  postPatch = "patchShebangs --host strace-graph";

  configureFlags = [ "--enable-mpers=check" ];

  meta = with lib; {
    homepage = "https://strace.io/";
    description = "A system call tracer for Linux";
    license =  with licenses; [ lgpl21Plus gpl2Plus ]; # gpl2Plus is for the test suite
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ma27 ];
  };
}
