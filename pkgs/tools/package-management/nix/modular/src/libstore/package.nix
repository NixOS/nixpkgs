{
  lib,
  stdenv,
  mkMesonLibrary,

  unixtools,

  nix-util,
  boost,
  curl,
  aws-sdk-cpp,
  aws-crt-cpp,
  libseccomp,
  nlohmann_json,
  sqlite,

  busybox-sandbox-shell ? null,

  # Configuration Options

  version,

  embeddedSandboxShell ? stdenv.hostPlatform.isStatic,
}:

mkMesonLibrary (finalAttrs: {
  pname = "nix-store";
  inherit version;

  workDir = ./.;

  nativeBuildInputs = lib.optional embeddedSandboxShell unixtools.hexdump;

  buildInputs = [
    boost
    curl
    sqlite
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libseccomp
  # There have been issues building these dependencies
  ++
    lib.optional (stdenv.hostPlatform == stdenv.buildPlatform && (stdenv.isLinux || stdenv.isDarwin))
      # Nix >=2.33 doesn't depend on aws-sdk-cpp and only requires aws-crt-cpp for authenticated s3:// requests.
      (if lib.versionAtLeast (lib.versions.majorMinor version) "2.33" then aws-crt-cpp else aws-sdk-cpp);

  propagatedBuildInputs = [
    nix-util
    nlohmann_json
  ];

  mesonFlags = [
    (lib.mesonEnable "seccomp-sandboxing" stdenv.hostPlatform.isLinux)
    (lib.mesonBool "embedded-sandbox-shell" embeddedSandboxShell)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.mesonOption "sandbox-shell" "${busybox-sandbox-shell}/bin/busybox")
  ];

  meta = {
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };

})
