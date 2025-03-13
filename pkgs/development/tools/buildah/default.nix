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
  testers,
  buildah,
}:

buildGoModule rec {
  pname = "buildah";
  version = "1.39.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    rev = "v${version}";
    hash = "sha256-OmDchq0ngdDbgDUyrz/jRwrCI1FJNKeq7ZLMOK4B+z0=";
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

  buildInputs =
    [
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

  passthru.tests.version = testers.testVersion {
    package = buildah;
    command = ''
      XDG_DATA_HOME="$TMPDIR" XDG_CACHE_HOME="$TMPDIR" XDG_CONFIG_HOME="$TMPDIR" \
      buildah --version
    '';
  };

  meta = with lib; {
    description = "Tool which facilitates building OCI images";
    mainProgram = "buildah";
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
  };
}
