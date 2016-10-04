{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-2016-08-02-git";
  version = "1.0.16";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "a8f0714536d15668e0f561ec4d3324762c8cf030";
    sha256 = "0m4k55akd8cv5k8mfpm3rb3fz13z31l49pml7mgviv0hi3mnisqd";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs ];
  };
}
