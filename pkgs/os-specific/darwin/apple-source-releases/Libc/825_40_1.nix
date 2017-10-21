{ stdenv, appleDerivation, ed, unifdef }:

appleDerivation {
  phases = [ "unpackPhase" "installPhase" ];

  nativeBuildInputs = [ ed unifdef ];

  installPhase = ''
    export SRCROOT=$PWD
    export DSTROOT=$out
    export PUBLIC_HEADERS_FOLDER_PATH=include
    export PRIVATE_HEADERS_FOLDER_PATH=include
    bash xcodescripts/headers.sh
  '';
}
