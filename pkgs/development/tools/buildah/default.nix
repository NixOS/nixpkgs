{ stdenv
, buildGoPackage
, fetchFromGitHub
, installShellFiles
, pkg-config
, gpgme
, libgpgerror
, lvm2
, btrfs-progs
, libselinux
, libseccomp
}:

buildGoPackage rec {
  pname = "buildah";
  version = "1.14.9";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    rev = "v${version}";
    sha256 = "1vp59xp374wr7sbx89aikz4rv8fdg0a40v06saryxww9iqyvk8wp";
  };

  outputs = [ "out" "man" ];

  goPackagePath = "github.com/containers/buildah";

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs libselinux libseccomp ];

  patches = [ ./disable-go-module-mode.patch ];

  buildPhase = ''
    pushd go/src/${goPackagePath}
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
