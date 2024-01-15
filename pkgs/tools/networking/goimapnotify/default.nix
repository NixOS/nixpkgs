{ buildGoModule, fetchFromGitLab, lib, runtimeShell }:

buildGoModule rec {
  pname = "goimapnotify";
  version = "2.3.10";

  src = fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    rev = version;
    sha256 = "sha256-RGEHKOmJqy9Cz5GWfck3VBZD6Q3DySoTYg0+Do4sy/4=";
  };

  vendorHash = "sha256-DphGe9jbKo1aIfpF5kRYNSn/uIYHaRMrygda5t46svw=";

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
    maintainers = with maintainers; [ wohanley ];
    mainProgram = "goimapnotify";
  };
}
