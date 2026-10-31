{
  lib,
  stdenv,
  mkMesonLibrary,

  unixtools,
  freebsd,

  nix-util,
  boost,
  curl,
  cmake,
  aws-c-common,
  aws-crt-cpp,
  libseccomp,
  nlohmann_json,
  sqlite,

  busybox-sandbox-shell ? null,
  pkgsStatic,

  # Configuration Options

  version,

  embeddedSandboxShell ? stdenv.hostPlatform.isStatic,

  withSandboxShell ?
    stdenv.hostPlatform.isLinux
    || (lib.versionAtLeast version "2.35pre" && stdenv.hostPlatform.isFreeBSD),
  sandboxShell ?
    if stdenv.hostPlatform.isLinux then
      "${busybox-sandbox-shell}/bin/busybox"
    else if stdenv.hostPlatform.isFreeBSD then
      "${pkgsStatic.bash}/bin/bash"
    else
      null,

  withAWS ?
    # Default is this way because there have been issues building this dependency
    # TODO: aws-crt-cpp is broken on cygwin, find a good way to check that here
    lib.meta.availableOn stdenv.hostPlatform aws-c-common && !stdenv.hostPlatform.isCygwin,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-store";
  inherit version;

  workDir = ./.;

  nativeBuildInputs =
    lib.optionals embeddedSandboxShell [
      unixtools.hexdump
    ]
    ++ lib.optionals withAWS [
      cmake
    ];

  buildInputs = [
    boost
    curl
    sqlite
  ]
  ++ lib.optionals (lib.versionAtLeast version "2.35pre" && stdenv.hostPlatform.isFreeBSD) [
    freebsd.libjail
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libseccomp
  ]
  ++ lib.optionals withAWS [
    aws-crt-cpp
  ];

  propagatedBuildInputs = [
    nix-util
    nlohmann_json
  ];

  # Don't use the default name "build": that conflicts with an existing directory.
  mesonBuildDir = "meson-build-dir";

  mesonFlags = [
    (lib.mesonEnable "seccomp-sandboxing" stdenv.hostPlatform.isLinux)
    (lib.mesonBool "embedded-sandbox-shell" embeddedSandboxShell)
    (lib.mesonEnable "s3-aws-auth" withAWS)
  ]
  ++ lib.optionals withSandboxShell [
    (lib.mesonOption "sandbox-shell" sandboxShell)
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
