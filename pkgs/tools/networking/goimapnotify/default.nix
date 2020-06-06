{ buildGoPackage, fetchFromGitLab, lib }:

buildGoPackage rec {
  pname = "goimapnotify";
  version = "2.0";

  goPackagePath = "gitlab.com/shackra/goimapnotify";

  src = fetchFromGitLab {
    owner = "shackra";
    repo = "goimapnotify";
    rev = "${version}";
    sha256 = "1d42gd3m2rkvy985d181dbcm5i3f7xsg2z8z6s4bpvw24pfnzs42";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description =
      "Execute scripts on IMAP mailbox changes (new/deleted/updated messages) using IDLE";
    homepage = "https://gitlab.com/shackra/goimapnotify";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wohanley ];
  };
}
