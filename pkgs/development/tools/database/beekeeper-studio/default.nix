{ callPackage, stdenvNoCC, lib }:
let
  version = "3.4.3";
  appimage = callPackage ./appimage.nix {
    inherit version;
    sha256 = "1xfr3i4gsi13wj374yr5idhgs0q71s4h33yxdr7b7xjdg2gb8lp1";
  };
  dmg-x86_64 = callPackage ./dmg.nix {
    inherit version;
    sha256 = "sha256-EzqVQemNVitgprN2o/0+BBPEundNACIl2Y2izAKbuEw=";
    isArm = false;
  };
  dmg-aarch64 = callPackage ./dmg.nix {
    inherit version;
    sha256 = "1axki47hrxx5m0hrmjpxcya091lahqfnh2pd3zhn5dd496slq8an";
    isArm = true;
  };
in (
  if stdenvNoCC.isDarwin && stdenvNoCC.hostPlatform.isAarch64 then
    dmg-aarch64
  else if stdenvNoCC.isDarwin then
    dmg-x86_64
  else
    appimage
).overrideAttrs
(oldAttrs: {
  meta = with lib; {
    description = "Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more. Linux, MacOS, and Windows";
    homepage = "https://www.beekeeperstudio.io";
    changelog = "https://github.com/beekeeper-studio/beekeeper-studio/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ milogert alexnortung ];
  } // oldAttrs.meta // {
    platforms =
      appimage.meta.platforms
      ++ dmg-x86_64.meta.platforms
      ++ dmg-aarch64.meta.platforms;
  };
})
