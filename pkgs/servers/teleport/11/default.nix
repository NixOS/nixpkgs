{ callPackage, fetchpatch, ... }@args:
callPackage ../generic.nix ({
  version = "11.3.25";
  hash = "sha256-KIbRn90BUJp8Uc8GMHuIMMSn5tJQbxzE0ntngx1ELaE=";
  vendorHash = "sha256-hjMv/H4dlinlv3ku7i1km2/b+6uCdbznHtVOMIjDlUc=";
  yarnHash = "sha256-hip0WQVZpx2qfVDmEy4nk4UFYEjX1Xhj8HsIIQ8PF1Y=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-GJfUyiYQwcDTMqt+iik3mFI0f6mu13RJ2XuoDzlg9sU=";
    };
  };
  goPatches = [
    (fetchpatch {
      name = "recursive-chown-vuln-fix.patch";
      url = "https://github.com/gravitational/teleport/commit/1ffde1695bf9614df87a40a4845e315e227bb35d.patch";
      hash = "sha256-fcAlaJEcQJQl0TuzfXKg1nNdnDYmppD+ntDOLAT8xAY=";
    })
  ];
} // builtins.removeAttrs args [ "callPackage" "fetchpatch" ])
