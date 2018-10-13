{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kbfs-${version}";
  version = "2.6.0";

  goPackagePath = "github.com/keybase/kbfs";
  subPackages = [ "kbfsfuse" "kbfsgit/git-remote-keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "kbfs";
    rev = "v${version}";
    sha256 = "0i4f1bc0gcnax572s749m7zcpy53a0f9yzi4lwc312zzxi7krz2f";
  };

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io;
    description = "The Keybase FS FUSE driver";
    platforms = platforms.linux;
    maintainers = with maintainers; [ bennofs np ];
    license = licenses.bsd3;
  };
}
