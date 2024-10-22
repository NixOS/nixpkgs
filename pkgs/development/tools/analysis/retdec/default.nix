{ stdenv
, fetchFromGitHub
, fetchpatch
, fetchzip
, writeText
, lib
, openssl
, cmake
, autoconf
, automake
, libtool
, pkg-config
, bison
, flex
, groff
, perl
, python3
, ncurses
, time
, upx
, gtest
, libffi
, libxml2
, zlib
, enableTests ? true
, buildDevTools ? true
, compileYaraPatterns ? true
}:

let
  # all dependencies that are normally fetched during build time (the subdirectories of `deps`)
  # all of these need to be fetched through nix and applied via their <NAME>_URL cmake variable
  capstone = fetchFromGitHub {
    owner = "capstone-engine";
    repo = "capstone";
    rev = "5.0-rc2";
    sha256 = "sha256-nB7FcgisBa8rRDS3k31BbkYB+tdqA6Qyj9hqCnFW+ME=";
  };
  llvm = fetchFromGitHub {
    owner = "avast-tl";
    repo = "llvm";
    rev = "2a1f3d8a97241c6e91710be8f84cf3cf80c03390";
    sha256 = "sha256-+v1T0VI9R92ed9ViqsfYZMJtPCjPHCr4FenoYdLuFOU=";
  };
  yaracpp = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v4.2.0-rc1";
    sha256 = "sha256-WcN6ClYO2d+/MdG06RHx3kN0o0WVAY876dJiG7CwJ8w=";
  };
  yaramod = fetchFromGitHub {
    owner = "avast";
    repo = "yaramod";
    rev = "aa06dd408c492a8f4488774caf2ee105ccc23ab5";
    sha256 = "sha256-NVDRf2U5H92EN/Ks//uxNEaeKU+sT4VL4QyyYMO+zKk=";
  };
  keystone = fetchFromGitHub {
    # only for tests
    owner = "keystone-engine";
    repo = "keystone";
    rev = "d7ba8e378e5284e6384fc9ecd660ed5f6532e922";
    sha256 = "1yzw3v8xvxh1rysh97y0i8y9svzbglx2zbsqjhrfx18vngh0x58f";
  };

  retdec-support-version = "2019-03-08";
  retdec-support =
    { rev = retdec-support-version; } // # for checking the version against the expected version
    fetchzip {
      url = "https://github.com/avast-tl/retdec-support/releases/download/${retdec-support-version}/retdec-support_${retdec-support-version}.tar.xz";
      hash = "sha256-t1tx4MfLW/lwtbO5JQ1nrFBIOeMclq+0dENuXW+ahIM=";
      stripRoot = false;
    };

  check-dep = name: dep:
    ''
      context="$(grep ${name}_URL --after-context 1 cmake/deps.cmake)"
      expected="$(echo "$context" | grep --only-matching '".*"')"
      have="${dep.rev}"

      echo "checking ${name} dependency matches deps.cmake...";
      if ! echo "$expected" | grep -q "$have"; then
        printf '%s\n' "${name} version does not match!"  "  nix: $have, expected: $expected"
        false
      fi
    '';

  deps = {
    CAPSTONE = capstone;
    LLVM = llvm;
    YARA = yaracpp;
    YARAMOD = yaramod;
    SUPPORT_PKG = retdec-support;
  } // lib.optionalAttrs enableTests {
    KEYSTONE = keystone;
    # nixpkgs googletest is used
    # GOOGLETEST = googletest;
  };

  # overwrite install-share.py to copy instead of download.
  # we use this so the copy happens at the right time in the build,
  # otherwise, the build process cleans the directory.
  install-share =
    writeText
      "install-share.py"
      ''
        import os, sys, shutil, subprocess

        install_path, arch_url, sha256hash_ref, version = sys.argv[1:]
        support_dir = os.path.join(install_path, 'share', 'retdec', 'support')

        assert os.path.isdir(arch_url), "nix install-share.py expects a path for support url"

        os.makedirs(support_dir, exist_ok=True)
        shutil.copytree(arch_url, support_dir, dirs_exist_ok=True)
        subprocess.check_call(['chmod', '-R', 'u+w', support_dir])
      '';
in
stdenv.mkDerivation (self: {
  pname = "retdec";

  # If you update this you will also need to adjust the versions of the updated dependencies.
  # I've notified upstream about this problem here:
  # https://github.com/avast-tl/retdec/issues/412
  #
  # The dependencies and their sources are listed in this file:
  # https://github.com/avast/retdec/blob/master/cmake/deps.cmake
  version = "5.0";

  src = fetchFromGitHub {
    owner = "avast";
    repo = "retdec";
    rev = "refs/tags/v${self.version}";
    sha256 = "sha256-H4e+aSgdBBbG6X6DzHGiDEIASPwBVNVsfHyeBTQLAKI=";
  };

  patches = [
    # gcc 13 compatibility: https://github.com/avast/retdec/pull/1153
    (fetchpatch {
      url = "https://github.com/avast/retdec/commit/dbaab2c3d17b1eae22c581e8ab6bfefadf4ef6ae.patch";
      hash = "sha256-YqHYPGAGWT4x6C+CpsOSsOIZ+NPM2FBQtGQFs74OUIQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
    pkg-config
    bison
    flex
    groff
    perl
    python3
  ];

  buildInputs = [
    openssl
    ncurses
    libffi
    libxml2
    zlib
  ] ++ lib.optional self.doInstallCheck gtest;

  cmakeFlags = [
    (lib.cmakeBool "RETDEC_TESTS" self.doInstallCheck) # build tests
    (lib.cmakeBool "RETDEC_DEV_TOOLS" buildDevTools) # build tools e.g. capstone2llvmir, retdectool
    (lib.cmakeBool "RETDEC_COMPILE_YARA" compileYaraPatterns) # build and install compiled patterns
  ] ++ lib.mapAttrsToList (k: v: lib.cmakeFeature "${k}_URL" "${v}") deps;

  preConfigure =
    lib.concatStringsSep "\n" (lib.mapAttrsToList check-dep deps)
    +
    ''
      cp -v ${install-share} ./support/install-share.py

      # the CMakeLists assume CMAKE_INSTALL_BINDIR, etc are path components but in Nix, they are absolute.
      # therefore, we need to remove the unnecessary CMAKE_INSTALL_PREFIX prepend.
      substituteInPlace ./CMakeLists.txt \
        --replace-warn "''$"{CMAKE_INSTALL_PREFIX}/"''$"{RETDEC_INSTALL_BIN_DIR} "''$"{CMAKE_INSTALL_FULL_BINDIR} \
        --replace-warn "''$"{CMAKE_INSTALL_PREFIX}/"''$"{RETDEC_INSTALL_LIB_DIR} "''$"{CMAKE_INSTALL_FULL_LIBDIR} \

      # --replace "''$"{CMAKE_INSTALL_PREFIX}/"''$"{RETDEC_INSTALL_SUPPORT_DIR} "''$"{RETDEC_INSTALL_SUPPORT_DIR}
      # note! Nix does not set CMAKE_INSTALL_DATADIR to an absolute path, so this replacement would be incorrect

      # similarly for yaramod. here, we fix the LIBDIR to lib64. for whatever reason, only "lib64" works.
      substituteInPlace deps/yaramod/CMakeLists.txt \
        --replace-fail "''$"{YARAMOD_INSTALL_DIR}/"''$"{CMAKE_INSTALL_LIBDIR} "''$"{YARAMOD_INSTALL_DIR}/lib64 \
        --replace-fail CMAKE_ARGS 'CMAKE_ARGS -DCMAKE_INSTALL_LIBDIR=lib64'

      # yara needs write permissions in the generated source directory.
      echo ${lib.escapeShellArg ''
        ExternalProject_Add_Step(
          yara chmod WORKING_DIRECTORY ''${YARA_DIR}
          DEPENDEES download COMMAND chmod -R u+w .
        )
      ''} >> deps/yara/CMakeLists.txt

      # patch gtest to use the system package
      gtest=deps/googletest/CMakeLists.txt
      old="$(cat $gtest)"
      (echo 'find_package(GTest REQUIRED)'; echo "$old") > $gtest
      sed -i 's/ExternalProject_[^(]\+[(]/ set(IGNORED /g' $gtest

      substituteInPlace $gtest \
        --replace-fail '$'{GTEST_LIB} "GTest::gtest"\
        --replace-fail '$'{GMOCK_LIB} "GTest::gmock"\
        --replace-fail '$'{GTEST_MAIN_LIB} "GTest::gtest_main"\
        --replace-fail '$'{GMOCK_MAIN_LIB} "GTest::gmock_main"

      # without git history, there is no chance these tests will pass.
      substituteInPlace tests/utils/version_tests.cpp \
        --replace-quiet VersionTests DISABLED_VersionTests

      substituteInPlace scripts/retdec-utils.py \
        --replace-warn /usr/bin/time ${time} \
        --replace-warn /usr/local/bin/gtime ${time}
      substituteInPlace scripts/retdec-unpacker.py \
        --replace-warn "'upx'" "'${upx}'"
    '';

  doInstallCheck = enableTests;
  installCheckPhase = ''
    ${python3.interpreter} "$out/bin/retdec-tests-runner.py"

    rm -rf $out/bin/__pycache__
  '';

  meta = with lib; {
    description = "Retargetable machine-code decompiler based on LLVM";
    homepage = "https://retdec.com";
    license = licenses.mit;
    maintainers = with maintainers; [ katrinafyi ];
    platforms = [ "x86_64-linux" ];
  };
})
