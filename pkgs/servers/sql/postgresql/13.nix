import ./generic.nix {
  version = "13.14";
  hash = "sha256-uN8HhVGJiWC9UA3F04oXfpkFN234H+fytmChQH+mpe0=";
  muslPatches = {
    icu-collations-hack = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql14/icu-collations-hack.patch?id=56999e6d0265ceff5c5239f85fdd33e146f06cb7";
      hash = "sha256-wuwjvGHArkRNwFo40g3p43W32OrJohretlt6iSRlJKg=";
    };
    disable-test-collate-icu-utf8 = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql13/disable-test-collate.icu.utf8.patch?id=69faa146ec9fff3b981511068f17f9e629d4688b";
      hash = "sha256-jS/qxezaiaKhkWeMCXwpz1SDJwUWn9tzN0uKaZ3Ph2Y=";
    };
  };
}
