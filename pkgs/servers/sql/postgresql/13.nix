import ./generic.nix {
  version = "13.14";
  hash = "sha256-uN8HhVGJiWC9UA3F04oXfpkFN234H+fytmChQH+mpe0=";
  muslPatches = {
    disable-test-collate-icu-utf8 = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql13/disable-test-collate.icu.utf8.patch?id=69faa146ec9fff3b981511068f17f9e629d4688b";
      hash = "sha256-jS/qxezaiaKhkWeMCXwpz1SDJwUWn9tzN0uKaZ3Ph2Y=";
    };
  };
}
