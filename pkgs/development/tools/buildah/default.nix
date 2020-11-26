{ stdenv
, buildGoModule
, fetchFromGitHub
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
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    rev = "v${version}";
    sha256 = "13kqcdrdzkbg6h5za6hhkzdx4nbrg5yl97ydj2hfcakl00q4y0dp";
  };

  outputs = [ "out" "man" ];

  vendorSha256 = null;

  doCheck = false;

  nativeBuildInputs = [ installShellFiles pkg-config ];

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
    make GIT_COMMIT="unknown"
    make -C docs
  '';

  installPhase = ''
    install -Dm755 buildah $out/bin/buildah
    installShellCompletion --bash contrib/completions/bash/buildah
    make -C docs install PREFIX="$man"
  '';

  meta = with stdenv.lib; {
    description = "A tool which facilitates building OCI images";
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
