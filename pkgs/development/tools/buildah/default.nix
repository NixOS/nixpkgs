{ stdenv, buildGoPackage, fetchFromGitHub
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux, libseccomp
}:

let
  version = "1.10.1";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "containers";
    repo   = "buildah";
    sha256 = "0dki2v8j2jzbw49sdzcyjqbalbh70m0lgzrldgj6cc92mj896pxk";
  };

  goPackagePath = "github.com/containers/buildah";

in buildGoPackage rec {
  pname = "buildah";
  inherit version;
  inherit src;

  outputs = [ "bin" "man" "out" ];

  inherit goPackagePath;
  excludedPackages = [ "tests" ];

  # Optimizations break compilation of libseccomp c bindings
  hardeningDisable = [ "fortify" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs ostree libselinux libseccomp ];

  buildPhase = ''
    pushd go/src/${goPackagePath}
    patchShebangs .
    make GIT_COMMIT="unknown"
    install -Dm755 buildah $bin/bin/buildah
  '';

  postBuild = ''
    make -C docs install PREFIX="$man"
  '';

  meta = {
    description = "A tool which facilitates building OCI images";
    homepage = https://github.com/containers/buildah;
    maintainers = with stdenv.lib.maintainers; [ Profpatsch vdemeester ];
    license = stdenv.lib.licenses.asl20;
  };
}
