{ stdenv, buildGoPackage, fetchFromGitHub
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux, libseccomp
}:

buildGoPackage rec {
  pname = "buildah";
  version = "1.11.6";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "buildah";
    rev    = "v${version}";
    sha256 = "0slhq11nmqsp2rjfwldvcwlpj823ckfpipggkaxhcb66dv8ymm7n";
  };

  outputs = [ "bin" "man" "out" ];

  goPackagePath = "github.com/containers/buildah";
  excludedPackages = [ "tests" ];

  # Disable module-mode, because Go 1.13 automatically enables it if there is
  # go.mod file. Remove after https://github.com/NixOS/nixpkgs/pull/73380
  GO111MODULE = "off";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs ostree libselinux libseccomp ];

  patches = [ ./disable-go-module-mode.patch ];

  buildPhase = ''
    pushd go/src/${goPackagePath}
    make GIT_COMMIT="unknown"
    install -Dm755 buildah $bin/bin/buildah
  '';

  postBuild = ''
    make -C docs install PREFIX="$man"
  '';

  meta = with stdenv.lib; {
    description = "A tool which facilitates building OCI images";
    homepage = "https://github.com/containers/buildah";
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch vdemeester saschagrunert ];
  };
}
