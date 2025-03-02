{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  callPackage,
  buildGoModule,
  installShellFiles,
  buildPackages,
  zlib,
  sqlite,
  cmake,
  python3,
  ninja,
  perl,
  autoconf,
  automake,
  libtool,
  cctools,
  cacert,
  unzip,
  go,
  p11-kit,
}:
stdenv.mkDerivation rec {
  pname = "curl-impersonate-ff";
  version = "0.6.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "lwthiker";
    repo = "curl-impersonate";
    rev = "v${version}";
    hash = "sha256-ExmEhjJC8FPzx08RuKOhRxKgJ4Dh+ElEl+OUHzRCzZc=";
  };

  patches = [
    # Fix shebangs and commands in the NSS build scripts
    # (can't just patchShebangs or substituteInPlace since makefile unpacks it)
    ./curl-impersonate-0.6.1-fix-command-paths.patch

    # SOCKS5 heap buffer overflow - https://curl.se/docs/CVE-2023-38545.html
    (fetchpatch {
      name = "curl-impersonate-patch-cve-2023-38545.patch";
      url = "https://github.com/lwthiker/curl-impersonate/commit/e7b90a0d9c61b6954aca27d346750240e8b6644e.diff";
      hash = "sha256-jFrz4Q+MJGfNmwwzHhThado4c9hTd/+b/bfRsr3FW5k=";
    })
  ];

  # Disable blanket -Werror to fix build on `gcc-13` related to minor
  # warnings on `boringssl`.
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  strictDeps = true;

  depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      # Must come first so that it shadows the 'libtool' command but leaves 'libtoolize'
      cctools
    ]
    ++ [
      installShellFiles
      cmake
      python3
      python3.pythonOnBuildForHost.pkgs.gyp
      ninja
      perl
      autoconf
      automake
      libtool
      unzip
      go
    ];

  buildInputs = [
    zlib
    sqlite
  ];

  configureFlags = [
    "--with-ca-bundle=${
      if stdenv.hostPlatform.isDarwin then "/etc/ssl/cert.pem" else "/etc/ssl/certs/ca-certificates.crt"
    }"
    "--with-ca-path=${cacert}/etc/ssl/certs"
  ];

  buildFlags = [ "firefox-build" ];
  checkTarget = "firefox-checkbuild";
  installTargets = [ "firefox-install" ];

  doCheck = true;

  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  postUnpack = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: dep: "ln -sT ${dep.outPath} source/${name}") (
      lib.filterAttrs (n: v: v ? outPath) passthru.deps
    )
  );

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOPROXY=file://${passthru.boringssl-go-modules}
    export GOSUMDB=off

    # Need to get value of $out for this flag
    configureFlagsArray+=("--with-libnssckbi=$out/lib")
  '';

  postInstall =
    ''
      # Remove vestigial *-config script
      rm $out/bin/curl-impersonate-ff-config

      # Patch all shebangs of installed scripts
      patchShebangs $out/bin

      # Install headers
      make -C curl-*/include install
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      # Build and install completions for each curl binary

      # Patch in correct binary name and alias it to all scripts
      perl curl-*/scripts/completion.pl --curl $out/bin/curl-impersonate-ff --shell zsh >$TMPDIR/curl-impersonate-ff.zsh
      substituteInPlace $TMPDIR/curl-impersonate-ff.zsh \
        --replace-fail \
          '#compdef curl' \
          "#compdef curl-impersonate-ff$(find $out/bin -name 'curl_*' -printf ' %f=curl-impersonate-ff')"

      perl curl-*/scripts/completion.pl --curl $out/bin/curl-impersonate-ff --shell fish >$TMPDIR/curl-impersonate-ff.fish
      substituteInPlace $TMPDIR/curl-impersonate-ff.fish \
        --replace-fail \
          '--command curl' \
          "--command curl-impersonate-ff$(find $out/bin -name 'curl_*' -printf ' --command %f')"

      # Install zsh and fish completions
      installShellCompletion $TMPDIR/curl-impersonate-ff.{zsh,fish}
    '';

  preFixup =
    let
      libext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      # If libnssckbi.so is needed, link libnssckbi.so without needing nss in closure
      if grep -F nssckbi $out/lib/libcurl-impersonate-*${libext} &>/dev/null; then
        ln -s ${p11-kit}/lib/pkcs11/p11-kit-trust${libext} $out/lib/libnssckbi${libext}
        ${lib.optionalString stdenv.hostPlatform.isElf ''
          patchelf --add-needed libnssckbi${libext} $out/lib/libcurl-impersonate-*${libext}
        ''}
      fi
    '';

  disallowedReferences = [ go ];

  passthru = {
    deps = callPackage ./deps.nix { };

    updateScript = ./update.sh;

    boringssl-go-modules =
      (buildGoModule {
        inherit (passthru.deps."boringssl.zip") name;

        src = passthru.deps."boringssl.zip";
        vendorHash = "sha256-SNUsBiKOGWmkRdTVABVrlbLAVMfu0Q9IgDe+kFC5vXs=";

        nativeBuildInputs = [ unzip ];

        proxyVendor = true;
      }).goModules;
  };

  meta = with lib; {
    description = "Special build of curl that can impersonate Chrome & Firefox";
    homepage = "https://github.com/lwthiker/curl-impersonate";
    license = with licenses; [
      curl
      mit
    ];
    maintainers = with maintainers; [ deliciouslytyped ];
    platforms = platforms.unix;
    mainProgram = "curl-impersonate-ff";
  };
}
