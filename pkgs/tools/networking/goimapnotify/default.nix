{ buildGoModule, fetchFromGitLab, lib, runtimeShell }:

buildGoModule rec {
  pname = "goimapnotify";
  version = "2.3.7";

  src = fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    rev = version;
    sha256 = "sha256-Wot+E+rDgXQ4FVgdfqe6a3O9oYUK3X1xImC33eDuUBo=";
  };

  vendorSha256 = "sha256-DphGe9jbKo1aIfpF5kRYNSn/uIYHaRMrygda5t46svw=";

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
