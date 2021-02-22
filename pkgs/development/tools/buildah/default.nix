{ lib
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
}:

buildGoModule rec {
  pname = "buildah";
  version = "1.19.6";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    rev = "v${version}";
    sha256 = "sha256-YTguBkQcMNjHMVMEN3/P+8fOC5eqmQvlRd1ny9umS/4=";
  };

  outputs = [ "out" "man" ];

  patches = [
    ../../../applications/virtualization/podman/remove-unconfigured-runtime-warn.patch
  ];

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ go-md2man installShellFiles pkg-config ];

  buildInputs = [
    btrfs-progs
    gpgme
    libapparmor
    libseccomp
    libselinux
    lvm2
  ];

  buildPhase = ''
    patchShebangs .
    make bin/buildah GIT_COMMIT="unknown"
    make -C docs GOMD2MAN="${go-md2man}/bin/go-md2man"
  '';

  installPhase = ''
    install -Dm755 bin/buildah $out/bin/buildah
    installShellCompletion --bash contrib/completions/bash/buildah
    make -C docs install PREFIX="$man"
  '';

  meta = with lib; {
    description = "A tool which facilitates building OCI images";
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
