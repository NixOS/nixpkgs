{ stdenv, buildGoPackage, fetchFromGitHub
, gpgme, libgpgerror, lvm2, btrfs-progs, pkg-config, libselinux, libseccomp
}:

buildGoPackage rec {
  pname = "buildah";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "buildah";
    rev    = "v${version}";
    sha256 = "1475k8h1l8rbbs6hyq9gxksh9884l1674z77fmiyr5vzql5yf7ca";
  };

  outputs = [ "bin" "man" "out" ];

  goPackagePath = "github.com/containers/buildah";
  excludedPackages = [ "tests" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs libselinux libseccomp ];

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
    homepage = "https://buildah.io/";
    changelog = "https://github.com/containers/buildah/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch vdemeester saschagrunert ];
  };
}
