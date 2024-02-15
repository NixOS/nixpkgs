{ lib
, cmake
, fetchFromGitHub
, fetchpatch
, git
, llvmPackages
, nixosTests
, overrideCC
, perl
, python3
, stdenv
, openssl_1_1
}:

let
  buildStdenv = overrideCC stdenv llvmPackages.clangUseLLVM;
in
buildStdenv.mkDerivation rec {
  pname = "osquery";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "osquery";
    repo = "osquery";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-Q6PQVnBjAjAlR725fyny+RhQFUNwxWGjLDuS5p9JKlU=";
  };

  patches = [
    ./Remove-git-reset.patch
    ./Use-locale.h-instead-of-removed-xlocale.h-header.patch
    ./Remove-circular-definition-of-AUDIT_FILTER_EXCLUDE.patch
    # For current state of compilation against glibc in the clangWithLLVM toolchain, refer to the upstream issue in https://github.com/osquery/osquery/issues/7823.
    ./Remove-system-controls-table.patch

    # osquery uses a vendored boost library that still relies on old standard types (e.g. `std::unary_function`)
    # which have been removed as of C++17. The patch is already checked in upstream, but there have been no
    # releases yet. Can likely be removed with versions > 5.10.2.
    (fetchpatch {
      name = "fix-build-on-clang-16.patch";
      url  = "https://github.com/osquery/osquery/commit/222991a15b4ae0a0fb919e4965603616536e1b0a.patch";
      hash = "sha256-PdzEoeR1LXVri1Cd+7KMhKmDC8yZhAx3f1+9tjLJKyo=";
    })
  ];


  buildInputs = [
    llvmPackages.libunwind
  ];
  nativeBuildInputs = [
    cmake
    git
    perl
    python3
  ];

  postPatch = ''
    substituteInPlace cmake/install_directives.cmake --replace "/control" "control"
    # This is required to build libarchive with our glibc version
    # which provides the ARC4RANDOM_BUF function
    substituteInPlace libraries/cmake/source/libarchive/CMakeLists.txt --replace "  target_compile_definitions(thirdparty_libarchive PRIVATE" "  target_compile_definitions(thirdparty_libarchive PRIVATE HAVE_ARC4RANDOM_BUF"
    # We need to override this hash because we use our own openssl 1.1 version
    substituteInPlace libraries/cmake/formula/openssl/CMakeLists.txt --replace \
      "d7939ce614029cdff0b6c20f0e2e5703158a489a72b2507b8bd51bf8c8fd10ca" \
      "$(sha256sum ${openssl_1_1.src} | cut -f1 '-d ')"
    cat libraries/cmake/formula/openssl/CMakeLists.txt
  '';

  # For explanation of these deletions, refer to the ./Use-locale.h-instead-of-removed-xlocale.h-header.patch file.
  preConfigure = ''
    find libraries/cmake/source -name 'config.h' -exec sed -i '/#define HAVE_XLOCALE_H 1/d' {} \;
  '';

  cmakeFlags = [
    "-DOSQUERY_VERSION=${version}"
    "-DOSQUERY_OPENSSL_ARCHIVE_PATH=${openssl_1_1.src}"
  ];

  postFixup = ''
    patchelf --set-rpath "${llvmPackages.libunwind}/lib:$(patchelf --print-rpath $out/bin/osqueryd)" "$out/bin/osqueryd"
  '';

  passthru.tests.osquery = nixosTests.osquery;

  meta = with lib; {
    description = "SQL powered operating system instrumentation, monitoring, and analytics";
    longDescription = ''
      The system controls table is not included as it does not presently compile with glibc >= 2.32.
      For more information, refer to https://github.com/osquery/osquery/issues/7823
    '';
    homepage = "https://osquery.io";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ znewman01 lewo ];
  };
}
