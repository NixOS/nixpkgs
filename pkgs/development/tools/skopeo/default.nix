{ stdenv, lib, buildGoPackage, fetchFromGitHub, runCommand
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux
, go-md2man }:

with stdenv.lib;

let
  version = "0.1.34";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    sha256 = "1drbbjqih69nvgynjcz0js0vi6sgsax8565zbrmf8fkbk609c7r3";
  };

  defaultPolicyFile = runCommand "skopeo-default-policy.json" {} "cp ${src}/default-policy.json $out";

  goPackagePath = "github.com/containers/skopeo";

in
buildGoPackage rec {
  name = "skopeo-${version}";
  inherit src goPackagePath;

  outputs = [ "bin" "man" "out" ];

  excludedPackages = "integration";

  nativeBuildInputs = [ pkgconfig (lib.getBin go-md2man) ];
  buildInputs = [ gpgme ] ++ lib.optionals stdenv.isLinux [ libgpgerror lvm2 btrfs-progs ostree libselinux ];

  buildFlagsArray = ''
    -ldflags=
    -X github.com/containers/skopeo/vendor/github.com/containers/image/signature.systemDefaultPolicyPath=${defaultPolicyFile}
    -X github.com/containers/skopeo/vendor/github.com/containers/image/internal/tmpdir.unixTempDirForBigFiles=/tmp
  '';

  preBuild = ''
    export CGO_CFLAGS="$CFLAGS"
    export CGO_LDFLAGS="$LDFLAGS"
  '';

  postBuild = ''
    # depends on buildGoPackage not changing …
    pushd ./go/src/${goPackagePath}
    make install-docs MANINSTALLDIR="$man"
    popd
  '';

  meta = {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = https://github.com/projectatomic/skopeo;
    maintainers = with stdenv.lib.maintainers; [ vdemeester lewo ];
    license = stdenv.lib.licenses.asl20;
  };
}
