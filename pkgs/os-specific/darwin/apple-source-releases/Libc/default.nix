{ appleDerivation', stdenvNoCC, ed, unifdef, Libc_10-9 }:

appleDerivation' stdenvNoCC {
  nativeBuildInputs = [ ed unifdef ];

  patches = [
    ./0001-Define-TARGET_OS_EMBEDDED-in-std-lib-io-if-not-defin.patch
  ];

  installPhase = ''
    export SRCROOT=$PWD
    export DSTROOT=$out
    export PUBLIC_HEADERS_FOLDER_PATH=include
    export PRIVATE_HEADERS_FOLDER_PATH=include
    bash xcodescripts/headers.sh

    cp ${./CrashReporterClient.h} $out/include/CrashReporterClient.h

    cp ${Libc_10-9}/include/NSSystemDirectories.h $out/include
  '';

  appleHeaders = builtins.readFile ./headers.txt;
}
