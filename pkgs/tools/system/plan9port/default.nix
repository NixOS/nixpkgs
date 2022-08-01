{ lib, stdenv, fetchFromGitHub
, fontconfig, freetype, libX11, libXext, libXt, xorgproto
, Carbon, Cocoa, IOKit, Metal, QuartzCore, DarwinTools
, perl # For building web manuals
, which
}:

stdenv.mkDerivation rec {
  pname = "plan9port";
  version = "2021-10-19";

  src = fetchFromGitHub {
    owner = "9fans";
    repo = pname;
    rev = "d0d440860f2000a1560abb3f593cdc325fcead4c";
    hash = "sha256-2aYXqPGwrReyFPrLDtEjgQd/RJjpOfI3ge/tDocYpRQ=";
  };

  postPatch = ''
    substituteInPlace bin/9c \
      --replace 'which uniq' '${which}/bin/which uniq'
  '';

  buildInputs = [ perl ] ++ (if !stdenv.isDarwin then [
    fontconfig
    freetype # fontsrv wants ft2build.h
    libX11
    libXext
    libXt
    xorgproto
  ] else [
    Carbon
    Cocoa
    IOKit
    Metal
    QuartzCore
    DarwinTools
  ]);

  builder = ./builder.sh;
  libXt_dev = libXt.dev;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/9 rc -c 'echo rc is working.'

    # 9l can find and use its libs
    cd $TMP
    cat >test.c <<EOF
    #include <u.h>
    #include <libc.h>
    #include <thread.h>
    void
    threadmain(int argc, char **argv)
    {
        threadexitsall(nil);
    }
    EOF
    $out/bin/9 9c -o test.o test.c
    $out/bin/9 9l -o test test.o
    ./test
  '';

  meta = with lib; {
    homepage = "https://9fans.github.io/plan9port/";
    description = "Plan 9 from User Space";
    longDescription = ''
      Plan 9 from User Space (aka plan9port) is a port of many Plan 9 programs
      from their native Plan 9 environment to Unix-like operating systems.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [
      AndersonTorres
      bbarker
      ehmry
      ftrvxmtrx
      kovirobi
      ylh
    ];
    mainProgram = "9";
    platforms = platforms.unix;
    # TODO: revisit this when the sdk situation on x86_64-darwin changes
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
# TODO: investigate the mouse chording support patch
