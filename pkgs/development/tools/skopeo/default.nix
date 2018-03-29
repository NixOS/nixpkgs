{ stdenv, lib, buildGoPackage, fetchFromGitHub, runCommand
, gpgme, libgpgerror, devicemapper, btrfs-progs, pkgconfig, ostree, libselinux
, go-md2man }:

with stdenv.lib;

let
  version = "0.1.29";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "projectatomic";
    repo = "skopeo";
    sha256 = "1lhzbyj2mm25x12s7g2jx4v8w19izjwlgx4lml13r5yy1spn65k2";
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

  buildFlagsArray = "-ldflags= -X github.com/projectatomic/skopeo/vendor/github.com/containers/image/signature.systemDefaultPolicyPath=${defaultPolicyFile}";

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
