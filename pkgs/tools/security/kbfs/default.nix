{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-${version}";
  version = "1.0.44";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" "kbfsgit/git-remote-keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "v${version}";
    sha256 = "1vjgzif8ki9xrlcghpzkvqwfwvaq63llf52s03m3d2vkyigmgp78";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs np ];
  };
}
