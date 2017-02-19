{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-${version}";
  version = "20170209.d1db463";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "d1db46315d9271f21ca2700a84ca19767e638296";
    sha256 = "12i2m370r27mmn37s55krdkhr5k8kpl3x8y3gzg7w5zn2wiw8i1g";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs ];
  };
}
