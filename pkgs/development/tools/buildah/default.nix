{ stdenv, buildGoPackage, fetchFromGitHub
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux, libseccomp
}:

buildGoPackage rec {
  pname = "buildah";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "buildah";
    rev    = "v${version}";
    sha256 = "0860ynv93gbicpczfapvrd558dzbqicy9rv4ivyjhb6yyfgy4qai";
  };

  outputs = [ "bin" "man" "out" ];

  goPackagePath = "github.com/containers/buildah";
  excludedPackages = [ "tests" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs ostree libselinux libseccomp ];

  patches = [ ./disable-go-module-mode.patch ];

  buildPhase = ''
    pushd go/src/${goPackagePath}
    make GIT_COMMIT="unknown"
    install -Dm755 buildah $bin/bin/buildah
    install -Dm444 contrib/completions/bash/buildah $bin/share/bash-completion/completions/buildah
  '';

  postBuild = ''
    make -C docs install PREFIX="$man"
  '';

  meta = with stdenv.lib; {
    description = "A tool which facilitates building OCI images";
    homepage = "https://github.com/containers/buildah";
    changelog = "https://github.com/containers/buildah/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch vdemeester saschagrunert ];
  };
}
