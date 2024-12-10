{
  callPackage,
  fetchFromGitHub,
}:

callPackage ./generic.nix rec {
  pname = "shorter-pixel-dungeon";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Shorter-Pixel-Dungeon";
    rev = "Short-${version}";
    hash = "sha256-dfBFAXlMjazTjvvRZ87H48OmitZuHhaa3qUF81pF4wc=";
  };

  postPatch = ''
    substituteInPlace build.gradle \
      --replace-fail "gdxControllersVersion = '2.2.4-SNAPSHOT'" "gdxControllersVersion = '2.2.3'"
  '';

  depsHash = "sha256-MUUeWZUCVPakK1MJwn0lPnjAlLpPWB/J17Ad68XRcHg=";

  desktopName = "Shorter Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Shorter-Pixel-Dungeon";
    downloadPage = "https://github.com/TrashboxBobylev/Shorter-Pixel-Dungeon/releases";
    description = "A shorter fork of the Shattered Pixel Dungeon roguelike";
  };
}
