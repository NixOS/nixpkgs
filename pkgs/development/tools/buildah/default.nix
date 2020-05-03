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
  version = "1.14.8";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "buildah";
    rev = "v${version}";
    sha256 = "187cvb3i5cwm7cwxmzpl2ca7900yb6v6b6cybyz5mnd5ccy5ff1q";
  };

  outputs = [ "bin" "man" "out" ];

  goPackagePath = "github.com/containers/buildah";
  excludedPackages = [ "tests" ];

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs libselinux libseccomp ];

  patches = [ ./disable-go-module-mode.patch ];

  buildPhase = ''
    pushd go/src/${goPackagePath}
    make GIT_COMMIT="unknown"
    install -Dm755 buildah $bin/bin/buildah
    installShellCompletion --bash contrib/completions/bash/buildah
  '';

  postBuild = ''
    make -C docs install PREFIX="$man"
  '';

  meta = with stdenv.lib; {
    description = "A tool which facilitates building OCI images";
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch ] ++ teams.podman.members;
  };
}
