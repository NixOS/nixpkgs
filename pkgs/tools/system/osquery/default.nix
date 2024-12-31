{ lib
, cmake
, fetchFromGitHub
, fetchzip
, fetchurl
, git
, perl
, python3
, stdenvNoCC
, ninja
, autoPatchelfHook
, writeShellApplication
, jq
, removeReferencesTo
, nixosTests
}:

let

  version = "5.12.2";

  opensslVersion = "3.2.1";

  opensslSha256 = "83c7329fe52c850677d75e5d0b0ca245309b97e8ecbcfdc1dfdc4ab9fac35b39";

  src = fetchFromGitHub {
    owner = "osquery";
    repo = "osquery";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-PJrGAqDxo5l6jtQdpTqraR195G6kaLQ2ik08WtlWEmk=";
  };

  extractOpensslInfo = writeShellApplication {
    name = "extractOpensslInfo";
    text = ''
      if [ $# -ne 1 ]; then
        echo "Usage: $0 <osquery-source-directory>"
        exit 1
      fi
      opensslCmake="$1"/libraries/cmake/formula/openssl/CMakeLists.txt
      version=$(gawk 'match($0, /OPENSSL_VERSION "(.*)"/, a) {print a[1]}' < "$opensslCmake")
      sha256=$(gawk 'match($0, /OPENSSL_ARCHIVE_SHA256 "(.*)"/, a) {print a[1]}' < "$opensslCmake")
      echo "{\"version\": \"$version\", \"sha256\": \"$sha256\"}"
    '';
  };

  opensslSrc = fetchurl {
    url = "https://www.openssl.org/source/openssl-${opensslVersion}.tar.gz";
    sha256 = opensslSha256;
  };

  toolchain = import ./toolchain-bin.nix { inherit autoPatchelfHook stdenvNoCC lib fetchzip; };

in

stdenvNoCC.mkDerivation rec {

  pname = "osquery";

  inherit src version;

  patches = [
    ./Remove-git-reset.patch
  ];

  nativeBuildInputs = [
    cmake
    git
    perl
    python3
    ninja
    autoPatchelfHook
    extractOpensslInfo
    jq
    removeReferencesTo
  ];

  postPatch = ''
    substituteInPlace cmake/install_directives.cmake --replace "/control" "control"
  '';

  configurePhase = ''
    expectedOpensslVersion=$(extractOpensslInfo . | jq -r .version)
    expectedOpensslSha256=$(extractOpensslInfo . | jq -r .sha256)

    if [ "$expectedOpensslVersion" != "${opensslVersion}" ]; then
      echo "openssl version mismatch: expected=$expectedOpensslVersion actual=${opensslVersion}"
      opensslMismatch=1
    fi

    if [ "$expectedOpensslSha256" != "${opensslSha256}" ]; then
      echo "openssl sha256 mismatch: expected=$expectedOpensslSha256 actual=${opensslSha256}"
      opensslMismatch=1
    fi

    if [ -n "$opensslMismatch" ]; then
      exit 1
    fi

    mkdir build
    cd build
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DOSQUERY_TOOLCHAIN_SYSROOT=${toolchain} \
      -DOSQUERY_VERSION=${version} \
      -DCMAKE_PREFIX_PATH=${toolchain}/usr/lib/cmake \
      -DCMAKE_LIBRARY_PATH=${toolchain}/usr/lib \
      -DOSQUERY_OPENSSL_ARCHIVE_PATH=${opensslSrc} \
      -GNinja
  '';

  disallowedReferences = [ toolchain ];

  postInstall = ''
    rm -rf $out/control
    remove-references-to -t ${toolchain} $out/bin/osqueryd
  '';

  passthru = {
    inherit extractOpensslInfo opensslSrc toolchain;
    tests = {
      inherit (nixosTests) osquery;
    };
  };

  meta = with lib; {
    description = "SQL powered operating system instrumentation, monitoring, and analytics";
    homepage = "https://osquery.io";
    license = with licenses; [ gpl2Only asl20 ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with maintainers; [ znewman01 lewo squalus ];
  };
}
