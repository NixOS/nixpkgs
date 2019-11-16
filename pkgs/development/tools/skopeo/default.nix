{ stdenv, lib, buildGoPackage, fetchFromGitHub, runCommand
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux
, go-md2man }:

with stdenv.lib;

let
  version = "0.1.39";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "containers";
    repo = "skopeo";
    sha256 = "1jkxmvh079pd9j4aa39ilmclwafnjs0yqdiigwh8cj7yf97x4vsi";
  };

  defaultPolicyFile = runCommand "skopeo-default-policy.json" {} "cp ${src}/default-policy.json $out";

  goPackagePath = "github.com/containers/skopeo";

in
buildGoPackage {
  pname = "skopeo";
  inherit version;
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
    make install-docs MANINSTALLDIR="$man/share/man"
    popd
  '';

  meta = {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = https://github.com/projectatomic/skopeo;
    maintainers = with stdenv.lib.maintainers; [ vdemeester lewo ];
    license = stdenv.lib.licenses.asl20;
  };
}
