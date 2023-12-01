{ stdenv, lib, fetchgit, cmake, perl, libubox, json_c }:

stdenv.mkDerivation {
  pname = "uqmi";
  version = "unstable-2019-06-27";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uqmi.git";
    rev = "1965c713937495a5cb029165c16acdb6572c3f87";
    sha256 = "1gn8sdcl4lwfs3lwabmnjbvdhhk1l42bwbajwds7j4936fpbklx0";
  };

  postPatch = ''
    substituteInPlace data/gen-header.pl --replace /usr/bin/env ""
    patchShebangs .
  '';

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ libubox json_c ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
    # Needed with GCC 12 but breaks on darwin (with clang) or older gcc
    "-Wno-error=dangling-pointer"
  ]);

  meta = with lib; {
    description = "Tiny QMI command line utility";
    homepage = "https://git.openwrt.org/?p=project/uqmi.git;a=summary";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz mkg20001 ];
  };
}
