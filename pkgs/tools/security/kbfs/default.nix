{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-2016-11-18-git";
  version = "1.0.2";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "aac615d7c50e7512a51a133c14cb699d9941ba8c";
    sha256 = "0vah6x37g2w1f7mb5x16f1815608mvv2d1mrpkpnhz2gz7qzz6bv";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs ];
  };
}
