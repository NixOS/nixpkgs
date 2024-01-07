{ lib
, fetchFromGitHub
, version
, suffix ? ""
, hash ? null
, src ? fetchFromGitHub { owner = "NixOS"; repo = "nix"; rev = version; inherit hash; }
, patches ? [ ]
, maintainers ? with lib.maintainers; [ eelco lovesegfault artturin ]
}:
assert (hash == null) -> (src != null);
let
  atLeast24 = lib.versionAtLeast version "2.4pre";
  atLeast25 = lib.versionAtLeast version "2.5pre";
  atLeast27 = lib.versionAtLeast version "2.7pre";
  atLeast210 = lib.versionAtLeast version "2.10pre";
  atLeast213 = lib.versionAtLeast version "2.13pre";
  atLeast214 = lib.versionAtLeast version "2.14pre";
in
{ stdenv
, autoconf-archive
, autoreconfHook
, bash
, bison
, boehmgc
, boost
, brotli
, busybox-sandbox-shell
, bzip2
, callPackage
, coreutils
, curl
, docbook_xsl_ns
, docbook5
, editline
, flex
, gnutar
, gtest
, gzip
, jq
, lib
, libarchive
, libcpuid
, libsodium
, libxml2
, libxslt
, lowdown
, mdbook
, mdbook-linkcheck
, nlohmann_json
, openssl
, perl
, pkg-config
, rapidcheck
, Security
, sqlite
, util-linuxMinimal
, xz

, enableDocumentation ? !atLeast24 || (
    (stdenv.hostPlatform == stdenv.buildPlatform) &&
    # mdbook errors out on risc-v due to a rustc bug
    # https://github.com/NixOS/nixpkgs/pull/242019
    # https://github.com/rust-lang/rust/issues/114473
    !stdenv.buildPlatform.isRiscV
  )
, enableStatic ? stdenv.hostPlatform.isStatic
, withAWS ? !enableStatic && (stdenv.isLinux || stdenv.isDarwin), aws-sdk-cpp
, withLibseccomp ? lib.meta.availableOn stdenv.hostPlatform libseccomp, libseccomp

, confDir
, stateDir
, storeDir

  # passthru tests
, pkgsi686Linux
}: let
self = stdenv.mkDerivation {
  pname = "nix";

  version = "${version}${suffix}";
  VERSION_SUFFIX = suffix;

  inherit src patches;

  outputs =
    [ "out" "dev" ]
    ++ lib.optionals enableDocumentation [ "man" "doc" ];

  hardeningEnable = lib.optionals (!stdenv.isDarwin) [ "pie" ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isMusl "fortify";

  nativeBuildInputs = [
    pkg-config
    autoconf-archive
    autoreconfHook
    bison
    flex
    jq
  ] ++ lib.optionals (enableDocumentation && !atLeast24) [
    libxslt
    libxml2
    docbook_xsl_ns
    docbook5
  ] ++ lib.optionals (enableDocumentation && atLeast24) [
    (lib.getBin lowdown)
    mdbook
  ] ++ lib.optionals (atLeast213 && enableDocumentation) [
    mdbook-linkcheck
  ] ++ lib.optionals stdenv.isLinux [
    util-linuxMinimal
  ];

  buildInputs = [
    boost
    brotli
    bzip2
    curl
    editline
    libsodium
    openssl
    sqlite
    xz
    gtest
    libarchive
    lowdown
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ] ++ lib.optionals (stdenv.isx86_64) [
    libcpuid
  ] ++ lib.optionals atLeast214 [
    rapidcheck
  ] ++ lib.optionals withLibseccomp [
    libseccomp
  ] ++ lib.optionals withAWS [
    aws-sdk-cpp
  ];

  propagatedBuildInputs = [
    boehmgc
  ] ++ lib.optionals (atLeast27) [
    nlohmann_json
  ];

  postPatch = ''
    patchShebangs --build tests
  '';

  preConfigure =
    # Copy libboost_context so we don't get all of Boost in our closure.
    # https://github.com/NixOS/nixpkgs/issues/45462
    lib.optionalString (!enableStatic) ''
      mkdir -p $out/lib
      cp -pd ${boost}/lib/{libboost_context*,libboost_thread*,libboost_system*} $out/lib
      rm -f $out/lib/*.a
      ${lib.optionalString stdenv.isLinux ''
        chmod u+w $out/lib/*.so.*
        patchelf --set-rpath $out/lib:${stdenv.cc.cc.lib}/lib $out/lib/libboost_thread.so.*
      ''}
    '' +
    # On all versions before c9f51e87057652db0013289a95deffba495b35e7, which
    # removes config.nix entirely and is not present in 2.3.x, we need to
    # patch around an issue where the Nix configure step pulls in the build
    # system's bash and other utilities when cross-compiling.
    lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform && !atLeast24) ''
      mkdir tmp/
      substitute corepkgs/config.nix.in tmp/config.nix.in \
        --subst-var-by bash ${bash}/bin/bash \
        --subst-var-by coreutils ${coreutils}/bin \
        --subst-var-by bzip2 ${bzip2}/bin/bzip2 \
        --subst-var-by gzip ${gzip}/bin/gzip \
        --subst-var-by xz ${xz}/bin/xz \
        --subst-var-by tar ${gnutar}/bin/tar \
        --subst-var-by tr ${coreutils}/bin/tr
      mv tmp/config.nix.in corepkgs/config.nix.in
    '';

  configureFlags = [
    "--with-store-dir=${storeDir}"
    "--localstatedir=${stateDir}"
    "--sysconfdir=${confDir}"
    "--enable-gc"
  ] ++ lib.optionals (!enableDocumentation) [
    "--disable-doc-gen"
  ] ++ lib.optionals stdenv.isLinux [
    "--with-sandbox-shell=${busybox-sandbox-shell}/bin/busybox"
  ] ++ lib.optionals (atLeast210 && stdenv.isLinux && stdenv.hostPlatform.isStatic) [
    "--enable-embedded-sandbox-shell"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform ? nix && stdenv.hostPlatform.nix ? system) [
    "--with-system=${stdenv.hostPlatform.nix.system}"
  ] ++ lib.optionals (!withLibseccomp) [
    # RISC-V support in progress https://github.com/seccomp/libseccomp/pull/50
    "--disable-seccomp-sandboxing"
  ] ++ lib.optionals (atLeast210 && stdenv.cc.isGNU && !enableStatic) [
    "--enable-lto"
  ];

  makeFlags = [
    # gcc runs multi-threaded LTO using make and does not yet detect the new fifo:/path style
    # of make jobserver. until gcc adds support for this we have to instruct make to use this
    # old style or LTO builds will run their linking on only one thread, which takes forever.
    "--jobserver-style=pipe"
    "profiledir=$(out)/etc/profile.d"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "PRECOMPILE_HEADERS=0"
    ++ lib.optional (stdenv.hostPlatform.isDarwin) "PRECOMPILE_HEADERS=1";

  installFlags = [ "sysconfdir=$(out)/etc" ];

  doInstallCheck = true;
  installCheckTarget = if atLeast210 then "installcheck" else null;

  # socket path becomes too long otherwise
  preInstallCheck = lib.optionalString stdenv.isDarwin ''
    export TMPDIR=$NIX_BUILD_TOP
  ''
  # See https://github.com/NixOS/nix/issues/5687
  + lib.optionalString (atLeast25 && stdenv.isDarwin) ''
    echo "exit 99" > tests/gc-non-blocking.sh
  '';

  separateDebugInfo = stdenv.isLinux && (atLeast24 -> !enableStatic);

  enableParallelBuilding = true;

  passthru = {
    inherit aws-sdk-cpp boehmgc;

    perl-bindings = perl.pkgs.toPerlModule (callPackage ./nix-perl.nix { nix = self; inherit Security; });

    tests = {
      nixi686 = pkgsi686Linux.nixVersions.${"nix_${lib.versions.major version}_${lib.versions.minor version}"};
    };
  };

  meta = with lib; {
    description = "Powerful package manager that makes package management reliable and reproducible";
    longDescription = ''
      Nix is a powerful package manager for Linux and other Unix systems that
      makes package management reliable and reproducible. It provides atomic
      upgrades and rollbacks, side-by-side installation of multiple versions of
      a package, multi-user package management and easy setup of build
      environments.
    '';
    homepage = "https://nixos.org/";
    license = licenses.lgpl2Plus;
    inherit maintainers;
    platforms = platforms.unix;
    outputsToInstall = [ "out" ] ++ optional enableDocumentation "man";
    mainProgram = "nix";
  };
};
in self
