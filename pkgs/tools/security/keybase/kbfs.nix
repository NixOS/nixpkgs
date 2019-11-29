{ stdenv, substituteAll, buildGoPackage, fetchFromGitHub, fuse, osxfuse, keybase }:

buildGoPackage {
  pname = "kbfs";

  inherit (keybase) src version;

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/kbfs/kbfsfuse" "go/kbfs/kbfsgit/git-remote-keybase" ];

  dontRenameImports = true;

  patches = [
    (substituteAll {
      src = ./fix-paths-kbfs.patch;
      fusermount = "${fuse}/bin/fusermount";
    })
  ];

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = "https://keybase.io/docs/kbfs";
    description = "The Keybase filesystem";
    platforms = platforms.unix;
    maintainers = with maintainers; [ rvolosatovs bennofs np ];
    license = licenses.bsd3;
  };
}
