{ buildGoModule, fetchFromGitLab, lib, runtimeShell }:

buildGoModule rec {
  pname = "goimapnotify";
  version = "2.3.2";

  src = fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    rev = version;
    sha256 = "sha256-pkpdIkabxz9bu0LnyU1/wu1qqPc/pQqCn8tePc2fIfg=";
  };

  vendorSha256 = "sha256-4+2p/7BAEk+1V0TII9Q2O2YNX0rvBiw2Ss7k1dsvUbk=";

  postPatch = ''
    for f in command.go command_test.go; do
      substituteInPlace $f --replace '"sh"' '"${runtimeShell}"'
    done
  '';

  meta = with lib; {
    description =
      "Execute scripts on IMAP mailbox changes (new/deleted/updated messages) using IDLE";
    homepage = "https://gitlab.com/shackra/goimapnotify";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wohanley ];
  };
}
