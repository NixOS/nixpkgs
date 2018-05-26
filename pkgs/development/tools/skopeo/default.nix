{ stdenv, lib, buildGoPackage, fetchFromGitHub, runCommand
, gpgme, libgpgerror, devicemapper, btrfs-progs, pkgconfig, ostree, libselinux
, go-md2man }:

with stdenv.lib;

let
  version = "0.1.30";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "projectatomic";
    repo = "skopeo";
    sha256 = "10lpiiki7mlhrp4bid40wys3lch7fars1whxsa5gy0frfgp89ghn";
  };

  defaultPolicyFile = runCommand "skopeo-default-policy.json" {} "cp ${src}/default-policy.json $out";

  goPackagePath = "github.com/projectatomic/skopeo";

in
buildGoPackage rec {
  name = "skopeo-${version}";
  inherit src goPackagePath;

  outputs = [ "bin" "man" "out" ];

  excludedPackages = "integration";

  nativeBuildInputs = [ pkgconfig (lib.getBin go-md2man) ];
  buildInputs = [ gpgme libgpgerror devicemapper btrfs-progs ostree libselinux ];

  buildFlagsArray = ''
    -ldflags=
    -X github.com/projectatomic/skopeo/vendor/github.com/containers/image/signature.systemDefaultPolicyPath=${defaultPolicyFile}
    -X github.com/projectatomic/skopeo/vendor/github.com/containers/image/internal/tmpdir.unixTempDirForBigFiles=/tmp
  '';

  preBuild = ''
    export CGO_CFLAGS="-I${getDev gpgme}/include -I${getDev libgpgerror}/include -I${getDev devicemapper}/include -I${getDev btrfs-progs}/include"
    export CGO_LDFLAGS="-L${getLib gpgme}/lib -L${getLib libgpgerror}/lib -L${getLib devicemapper}/lib"
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
