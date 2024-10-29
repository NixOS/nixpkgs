{ lib, appleDerivation', stdenvNoCC, ed, unifdef, fetchzip }:

appleDerivation' stdenvNoCC {
  nativeBuildInputs = [ ed unifdef ];

  patches = [
    ./0001-Define-TARGET_OS_EMBEDDED-in-std-lib-io-if-not-defin.patch
  ];

  installPhase = let Libc_old = fetchzip {
      url = "https://github.com/apple-oss-distributions/Libc/archive/refs/tags/Libc-997.90.3.tar.gz";
      hash = "sha256-B18RNO+Rai5XE52TKdJV7eknosTZ+bRERkiU12d/kPU=";
    };
  in ''
    export SRCROOT=$PWD
    export DSTROOT=$out
    export PUBLIC_HEADERS_FOLDER_PATH=include
    export PRIVATE_HEADERS_FOLDER_PATH=include
    bash xcodescripts/headers.sh

    cp ${./CrashReporterClient.h} $out/include/CrashReporterClient.h

    cp ${Libc_old}/include/NSSystemDirectories.h $out/include
  '';

  appleHeaders = builtins.readFile ./headers-10.13.6.txt;

  meta = {
    maintainers = with lib.maintainers; [ toonn ];
  };
}
