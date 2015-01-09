{ stdenv, fetchurl, fetchgit, fetchzip, perl, python }:

let
  osx_sdk = fetchgit {
    url = "https://github.com/samdmarshall/OSXPrivateSDK";
    rev = "refs/heads/master";
    sha256 = "04m71xhjyac42h7alxjsqsipq07hm85wibvm3h65dqafcbqkl1i1";
  };
  dispatch = fetchzip {
    url = "https://opensource.apple.com/tarballs/libdispatch/libdispatch-339.92.1.tar.gz";
    sha256 = "0faxm4r7lamz57m9pr72jwm0qiwcrcy5dsiff0g9qyfi10pnj5i4";
  };
in
stdenv.mkDerivation rec {
  version = "825.40.1";
  name = "libc-${version}";
  src = fetchurl {
    url = "https://opensource.apple.com/tarballs/Libc/Libc-${version}.tar.gz";
    sha256 = "0xsx1im52gwlmcrv4lnhhhn9dyk5ci6g27k6yvibn9vj8fzjxwcf";
  };

  buildInputs = [ perl ];

  patches = [ ./fileport.patch ];

  configurePhase = ''
    mkdir -p scratch
    mkdir -p scratch/System/sys
    ln -sv ${osx_sdk}/System/Library/Frameworks/System.framework/PrivateHeaders/sys/fsctl.h scratch/System/sys
    mkdir tmpbin
    ln -s /usr/bin/xcodebuild tmpbin
    ln -s /usr/sbin/dtrace tmpbin
    export PATH=$PATH:$(pwd -P)/tmpbin
  '';

  buildPhase = ''
    BASE=$(pwd -P)
    xcodebuild HEADER_SEARCH_PATHS="$BASE/fbsdcompat $BASE/pthreads $BASE/include $BASE/locale $BASE/locale/FreeBSD ${osx_sdk}/usr/local/include ${osx_sdk}/usr/include $BASE/stdtime/FreeBSD $BASE/gen ${osx_sdk}/System/Library/Frameworks/System.framework/PrivateHeaders $BASE/scratch ${osx_sdk}/System/Library/Frameworks/System.framework/PrivateHeaders/uuid $BASE/gdtoa"
  '';
}
