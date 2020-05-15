{ stdenv, buildGoModule, fetchFromGitHub, keybase }:

buildGoModule {
  pname = "kbfs";

  inherit (keybase) src version;

  subPackages = [ "go/kbfs/kbfsfuse" "go/kbfs/redirector" "go/kbfs/kbfsgit/git-remote-keybase" ];

  dontRenameImports = true;

  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = "https://keybase.io/docs/kbfs";
    description = "The Keybase filesystem";
    platforms = platforms.unix;
    maintainers = with maintainers; [ avaq rvolosatovs bennofs np ];
    license = licenses.bsd3;
  };
}