{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, go-md2man
, installShellFiles
, pkg-config
, gpgme
, lvm2
, btrfs-progs
, libapparmor
, libselinux
, libseccomp
, testers
, buildah
}:

buildGoModule rec {
  pname = "buildah";
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    rev = "v${version}";
    hash = "sha256-Ttz1D/jFbxFfpbT2VAkcao2AFwFRD8PLrH8yDSYt3AI=";
  };

  outputs = [ "out" "man" ];

  vendorHash = null;

  doCheck = false;

  nativeBuildInputs = [ go-md2man installShellFiles pkg-config ];

  buildInputs = [
    gpgme
  ] ++ lib.optionals stdenv.isLinux [
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
    description = "A tool which facilitates building OCI images";
    mainProgram = "buildah";
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
  };
}

