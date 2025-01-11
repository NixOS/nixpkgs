{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  freetype,
  libX11,
  libXext,
  libXt,
  xorgproto,
  perl, # For building web manuals
  which,
  ed,
  Carbon,
  Cocoa,
  IOKit,
  Metal,
  QuartzCore,
  DarwinTools, # For building on Darwin
}:

stdenv.mkDerivation rec {
  pname = "plan9port";
  version = "2024-10-22";

  src = fetchFromGitHub {
    owner = "9fans";
    repo = pname;
    rev = "61e362add9e1485bec1ab8261d729016850ec270";
    hash = "sha256-Hpz9yuBktgJEOQ4ZD03c37pO9wgbvtYjIreYusr0Dzw=";
  };

  postPatch = ''
    substituteInPlace bin/9c \
      --replace 'which uniq' '${which}/bin/which uniq'

    ed -sE INSTALL <<EOF
    # get /bin:/usr/bin out of PATH
    /^PATH=[^ ]*/s,,PATH=\$PATH:\$PLAN9/bin,
    # no xcbuild nonsense
    /^if.* = Darwin/+;/^fi/-c
    ${"\t"}export NPROC=$NIX_BUILD_CORES
    .
    # remove absolute include paths from fontsrv test
    /cc -o a.out -c -I.*freetype2/;/x11.c/j
    s/(-Iinclude).*-I[^ ]*/\1/
    wq
    EOF
  '';

  nativeBuildInputs = [ ed ];
  buildInputs =
    [
      perl
      which
    ]
    ++ (
      if !stdenv.hostPlatform.isDarwin then
        [
          fontconfig
          freetype # fontsrv uses these
          libX11
          libXext
          libXt
          xorgproto
        ]
      else
        [
          Carbon
          Cocoa
          IOKit
          Metal
          QuartzCore
          DarwinTools
        ]
    );

  configurePhase = ''
    runHook preConfigure
    cat >LOCAL.config <<EOF
    CC9='$(command -v $CC)'
    CFLAGS='$NIX_CFLAGS_COMPILE'
    LDFLAGS='$(for f in $NIX_LDFLAGS; do echo "-Wl,$f"; done | xargs echo)'
    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) "X11='${libXt.dev}/include'"}
    EOF

    # make '9' available in the path so there's some way to find out $PLAN9
    cat >LOCAL.INSTALL <<EOF
    #!$out/plan9/bin/rc
    mkdir $out/bin
    ln -s $out/plan9/bin/9 $out/bin/
    EOF
    chmod +x LOCAL.INSTALL

    # now, not in fixupPhase, so ./INSTALL works
    patchShebangs .
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    PLAN9_TARGET=$out/plan9 ./INSTALL -b
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r . $out/plan9
    cd $out/plan9

    ./INSTALL -c
    runHook postInstall
  '';

  dontPatchShebangs = true;

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
      bbarker
      ehmry
      ftrvxmtrx
      kovirobi
      matthewdargan
      ylh
    ];
    mainProgram = "9";
    platforms = platforms.unix;
  };
}
# TODO: investigate the mouse chording support patch
