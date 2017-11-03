{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-${version}";
  version = "20171004.40555d";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" "kbfsgit/git-remote-keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "40555dbc9c93a05f3a82053860df30e45c7bd779";
    sha256 = "08wj8fh1ja8kfzvbza5csy9mpfy39lifnzvfrnbj7vyyv88qc3h0";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs np ];
  };
}
