{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  go-md2man,
  installShellFiles,
  pkg-config,
  gpgme,
  lvm2,
  btrfs-progs,
  libapparmor,
  libselinux,
  libseccomp,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "buildah";
  version = "1.41.5";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NQ5nCU1uiw3SzPMo2rH4+GnAIbIzM9O0bJaXJg/rfZM=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = null;

  doCheck = false;

  # /nix/store/.../bin/ld: internal/mkcw/embed/entrypoint_amd64.o: relocation R_X86_64_32S against `.rodata.1' can not be used when making a PIE object; recompile with -fPIE
  hardeningDisable = [ "pie" ];

  nativeBuildInputs = [
    go-md2man
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    gpgme
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    btrfs-progs
    libapparmor
    libseccomp
    libselinux
    lvm2
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make bin/buildah
    make -C docs GOMD2MAN="go-md2man"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/buildah $out/bin/buildah
    installShellCompletion --bash contrib/completions/bash/buildah
    make -C docs install PREFIX="$man"
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Tool which facilitates building OCI images";
    mainProgram = "buildah";
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
  };
})
