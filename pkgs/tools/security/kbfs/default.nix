{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-${version}";
  version = "1.0.40";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" "kbfsgit/git-remote-keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "v${version}";
    sha256 = "1bgbzk3ykjb6y5sa5i9f6hwcp8b21dndq7iw9m8fdxh4n4mm6n9p";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs np ];
  };
}
