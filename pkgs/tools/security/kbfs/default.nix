{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-${version}";
  version = "20170922.f76290";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "f76290f6e1a8cbaa6046980c67c548fbff9e123a";
    sha256 = "1v086wmc0hly4b91y6xndfdhj981n2yr6nnb3rl6f4kwx291ih54";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs np ];
  };
}
