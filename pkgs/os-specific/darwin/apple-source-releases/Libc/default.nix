{ appleDerivation', stdenvNoCC, ed, unifdef, Libc_old, Libc_10-9 }:

appleDerivation' stdenvNoCC {
  nativeBuildInputs = [ ed unifdef ];

  patches = [
    ./0001-Define-TARGET_OS_EMBEDDED-in-std-lib-io-if-not-defin.patch
  ];

  # TODO: asl.h actually comes from syslog project now
  installPhase = ''
    export SRCROOT=$PWD
    export DSTROOT=$out
    export PUBLIC_HEADERS_FOLDER_PATH=include
    export PRIVATE_HEADERS_FOLDER_PATH=include
    bash xcodescripts/headers.sh

    cp ${./CrashReporterClient.h} $out/include/CrashReporterClient.h

    cp ${Libc_10-9}/include/NSSystemDirectories.h $out/include

    # Ugh Apple stopped releasing this stuff so we need an older one...
    cp    ${Libc_old}/include/spawn.h    $out/include
    cp    ${Libc_old}/include/setjmp.h   $out/include
    cp    ${Libc_old}/include/ucontext.h $out/include
    cp    ${Libc_old}/include/pthread*.h $out/include
    cp    ${Libc_old}/include/sched.h    $out/include
    cp -R ${Libc_old}/include/malloc     $out/include

    mkdir -p $out/include/libkern
    cp ${Libc_old}/include/asl.h                    $out/include
    cp ${Libc_old}/include/libproc.h                $out/include
    cp ${Libc_old}/include/libkern/OSAtomic.h       $out/include/libkern
    cp ${Libc_old}/include/libkern/OSCacheControl.h $out/include/libkern
  '';

  appleHeaders = builtins.readFile ./headers.txt;
}
