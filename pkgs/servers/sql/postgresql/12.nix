import ./generic.nix {
  version = "12.18";
  hash = "sha256-T5kZcl2UHOmGjgf+HtHTqGdIWZtIM4ZUdYOSi3TDkYo=";
  muslPatches = {
    icu-collations-hack = {
      url = "https://git.alpinelinux.org/aports/plain/testing/postgresql12/icu-collations-hack.patch?id=d5227c91adda59d4e7f55f13468f0314e8869174";
      hash = "sha256-wuwjvGHArkRNwFo40g3p43W32OrJohretlt6iSRlJKg=";
    };
  };
}
