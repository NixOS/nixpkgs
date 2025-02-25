{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  buildGoModule,
  installShellFiles,
  buildPackages,
  zlib,
  zstd,
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
  pname = "curl-impersonate-chrome";
  version = "0.8.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "yifeikong";
    repo = "curl-impersonate";
    rev = "v${version}";
    hash = "sha256-m6zeQUL+yBh3ixS+crbJWHX5TLa61A/3oqMz5UVELso=";
  };

  patches = [ ./disable-building-docs.patch ];

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
    zstd
    sqlite
  ];

  configureFlags = [
    "--with-ca-bundle=${
      if stdenv.hostPlatform.isDarwin then "/etc/ssl/cert.pem" else "/etc/ssl/certs/ca-certificates.crt"
    }"
    "--with-ca-path=${cacert}/etc/ssl/certs"
  ];

  buildFlags = [ "chrome-build" ];
  checkTarget = "chrome-checkbuild";
  installTargets = [ "chrome-install" ];

  doCheck = true;

  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  postUnpack =
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: dep: "ln -sT ${dep.outPath} source/${name}") (
        lib.filterAttrs (n: v: v ? outPath) passthru.deps
      )
    )
    + ''

      curltar=$(realpath -s source/curl-*.tar.gz)

      pushd "$(mktemp -d)"

      tar -xf "$curltar"

      pushd curl-curl-*/
      patchShebangs scripts
      popd

      rm "$curltar"
      tar -czf "$curltar" .

      popd
    '';

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
      rm $out/bin/curl-impersonate-chrome-config

      # Patch all shebangs of installed scripts
      patchShebangs $out/bin

      # Install headers
      make -C curl-*/include install
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      # Build and install completions for each curl binary

      # Patch in correct binary name and alias it to all scripts
      perl curl-*/scripts/completion.pl --curl $out/bin/curl-impersonate-chrome --shell zsh >$TMPDIR/curl-impersonate-chrome.zsh
      substituteInPlace $TMPDIR/curl-impersonate-chrome.zsh \
        --replace-fail \
          '#compdef curl' \
          "#compdef curl-impersonate-chrome$(find $out/bin -name 'curl_*' -printf ' %f=curl-impersonate-chrome')"

      perl curl-*/scripts/completion.pl --curl $out/bin/curl-impersonate-chrome --shell fish >$TMPDIR/curl-impersonate-chrome.fish
      substituteInPlace $TMPDIR/curl-impersonate-chrome.fish \
        --replace-fail \
          '--command curl' \
          "--command curl-impersonate-chrome$(find $out/bin -name 'curl_*' -printf ' --command %f')"

      # Install zsh and fish completions
      installShellCompletion $TMPDIR/curl-impersonate-chrome.{zsh,fish}
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
        vendorHash = "sha256-oKlwh+Oup3lVgqgq42vY3iLg62VboF9N565yK2W0XxI=";

        nativeBuildInputs = [ unzip ];

        proxyVendor = true;
      }).goModules;
  };

  meta = {
    description = "Special build of curl that can impersonate Chrome & Firefox";
    homepage = "https://github.com/yifeikong/curl-impersonate";
    license = with lib.licenses; [
      curl
      mit
    ];
    maintainers = with lib.maintainers; [ ggg ];
    platforms = lib.platforms.unix;
    mainProgram = "curl-impersonate-chrome";
  };
}
