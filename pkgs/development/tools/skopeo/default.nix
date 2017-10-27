{ stdenv, lib, buildGoPackage, fetchFromGitHub, gpgme, libgpgerror, devicemapper, btrfs-progs, pkgconfig, ostree }:

with stdenv.lib;

buildGoPackage rec {
  name = "skopeo-${version}";
  version = "0.1.23";
  rev = "v${version}";

  goPackagePath = "github.com/projectatomic/skopeo";
  excludedPackages = "integration";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gpgme libgpgerror devicemapper btrfs-progs ostree ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "projectatomic";
    repo = "skopeo";
    sha256 = "1axxnm87fpsd7q28v951ilhmzd42k8wyh741gdfdcajjwglfj0nn";
  };

  patches = [
    ./path.patch
  ];

  preBuild = ''
    export CGO_CFLAGS="-I${getDev gpgme}/include -I${getDev libgpgerror}/include -I${getDev devicemapper}/include -I${getDev btrfs-progs}/include"
    export CGO_LDFLAGS="-L${getLib gpgme}/lib -L${getLib libgpgerror}/lib -L${getLib devicemapper}/lib"
  '';

  postInstall = ''
    mkdir $bin/etc
    cp -v ./go/src/github.com/projectatomic/skopeo/default-policy.json $bin/etc/default-policy.json
  '';

  meta = {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = https://github.com/projectatomic/skopeo;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.asl20;
  };
}
