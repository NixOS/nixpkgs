{ stdenv, lib, buildGoPackage, fetchFromGitHub, runCommand
, gpgme, libgpgerror, devicemapper, btrfs-progs, pkgconfig, ostree, libselinux
, go-md2man }:

let
  version = "0.12";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "projectatomic";
    repo = "buildah";
    sha256 = "0xyq7rv0lj6bxwh2rnf44w9gjcqbdkfcdff88023b9vlsc8h4k0m";
  };
  goPackagePath = "github.com/projectatomic/buildah";

in buildGoPackage rec {
  name = "buildah-${version}";
  inherit src;

  outputs = [ "bin" "man" "out" ];

  inherit goPackagePath;
  excludedPackages = [ "tests" ];

  nativeBuildInputs = [ pkgconfig go-md2man.bin ];
  buildInputs = [ gpgme libgpgerror devicemapper btrfs-progs ostree libselinux ];

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
    homepage = https://github.com/projectatomic/buildah;
    maintainers = with stdenv.lib.maintainers; [ Profpatsch ];
    license = stdenv.lib.licenses.asl20;
  };
}
