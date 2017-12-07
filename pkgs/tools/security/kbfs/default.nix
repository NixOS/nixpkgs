{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-${version}";
  version = "20170429.44efa06";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "44efa0682d931d8489f5e84542e8d00baeb12592";
    sha256 = "1q6hklyr6zq3xr1azz1c6rlpsjc036f222cd20vf79m58dn906n5";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs np ];
  };
}
