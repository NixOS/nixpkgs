{ stdenv, lib, buildGoPackage, fetchFromGitHub, gpgme, libgpgerror, devicemapper, btrfs-progs }:

with stdenv.lib;

buildGoPackage rec {
  name = "skopeo-${version}";
  version = "0.1.18";
  rev = "v${version}";

  goPackagePath = "github.com/projectatomic/skopeo";
  excludedPackages = "integration";

  buildInputs = [ gpgme libgpgerror devicemapper btrfs-progs ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "projectatomic";
    repo = "skopeo";
    sha256 = "13k29i5hx909hvddl2xkyw4qzxq2q20ay9bkal3xi063s6l0sh0z";
  };

  preBuild = ''
    export CGO_CFLAGS="-I${getDev gpgme}/include -I${getDev libgpgerror}/include -I${getDev devicemapper}/include -I${getDev btrfs-progs}/include"
    export CGO_LDFLAGS="-L${getLib gpgme}/lib -L${getLib libgpgerror}/lib -L${getLib devicemapper}/lib"
  '';

  meta = {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/projectatomic/skopeo";
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.asl20;
  };
}
