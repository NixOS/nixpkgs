{ stdenv, lib, fetchgit, cmake, perl, libubox, json_c }:

stdenv.mkDerivation {
  pname = "uqmi";
  version = "unstable-2024-01-16";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uqmi.git";
    rev = "c3488b831ce6285c8107704156b9b8ed7d59deb3";
    hash = "sha256-O5CeLk0WYuBs3l5xBUk9kXDRMzFvYSRoqP28KJ5Ztos=";
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
    "-Wno-error=maybe-uninitialized"
  ] ++ lib.optionals stdenv.cc.isClang [
    "-Wno-error=sometimes-uninitialized"
  ]);

  meta = with lib; {
    description = "Tiny QMI command line utility";
    homepage = "https://git.openwrt.org/?p=project/uqmi.git;a=summary";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz mkg20001 ];
    mainProgram = "uqmi";
  };
}
