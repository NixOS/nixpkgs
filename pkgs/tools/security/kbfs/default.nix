{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-${version}";
  version = "20171004.70800d";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" "kbfsgit/git-remote-keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "70800d07bae3db4a0fbb132bedfa5a530c16ee6a";
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
