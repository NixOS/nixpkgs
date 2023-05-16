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
<<<<<<< HEAD
  version = "1.31.3";
=======
  version = "1.30.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Uqs4MlKwFz4EGd6HTGXqcLTSfYPJTpgKKyXmA3B3RjU=";
=======
    hash = "sha256-h0fipw3lJKy+VkGkh1XbZ6wUOg4001uURoJpjNq7QOs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  };

  meta = with lib; {
    description = "A tool which facilitates building OCI images";
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ] ++ teams.podman.members;
=======
    maintainers = with maintainers; [ Profpatsch ] ++ teams.podman.members;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
