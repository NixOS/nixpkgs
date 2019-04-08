{ stdenv, buildGoPackage, fetchFromGitHub
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux, libseccomp
, go-md2man }:

let
  version = "1.7.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "buildah";
    sha256 = "19rp5kgdgyjfvg23m8dqlv6g1cs2c57nnw64ifjv24hqhy1xc0qk";
  };
  goPackagePath = "github.com/containers/buildah";

in buildGoPackage rec {
  name = "buildah-${version}";
  inherit src;

  outputs = [ "bin" "man" "out" ];

  inherit goPackagePath;
  excludedPackages = [ "tests" ];

  # Optimizations break compilation of libseccomp c bindings
  hardeningDisable = [ "fortify" ];

  nativeBuildInputs = [ pkgconfig go-md2man.bin ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs ostree libselinux libseccomp ];

  # Copied from the skopeo package, doesn’t seem to make a difference?
  # If something related to these libs failed, uncomment these lines.
  /*preBuild = with lib; ''
    export CGO_CFLAGS="-I${getDev gpgme}/include -I${getDev libgpgerror}/include -I${getDev devicemapper}/include -I${getDev btrfs-progs}/include"
    export CGO_LDFLAGS="-L${getLib gpgme}/lib -L${getLib libgpgerror}/lib -L${getLib devicemapper}/lib"
  '';*/

  postBuild = ''
    # depends on buildGoPackage not changing …
    pushd ./go/src/${goPackagePath}/docs
    make docs
    make install PREFIX="$man"
    popd
  '';

  meta = {
    description = "A tool which facilitates building OCI images";
    homepage = https://github.com/containers/buildah;
    maintainers = with stdenv.lib.maintainers; [ Profpatsch ];
    license = stdenv.lib.licenses.asl20;
  };
}
