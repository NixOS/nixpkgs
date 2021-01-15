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
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    rev = "v${version}";
    sha256 = "1wzj8ll9z4pnzr5bz1rjq7fc98kw596zcwaamv8lh2pzwcfgi9ki";
  };

  outputs = [ "out" "man" ];

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
