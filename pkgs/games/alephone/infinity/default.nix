{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon-infinity";
  desktopName = "Marathon-Infinity";
  version = "20230119";
  icon = alephone.icons + "/marathon-infinity.png";

  zip = fetchurl {
    url =
      "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${version}/MarathonInfinity-${version}-Data.zip";
    sha256 = "sha256-0+xokhzWdXM+L4DBjWnfNVXZve4n1X/Aq6rxNGAFb3Q=";
  };

  meta = {
    description = "Third chapter of the Marathon trilogy";
    longDescription = ''
      Marathon Infinity takes the closed universe of the Marathon series and blows it wide open. The solo/co-op campaign, “Blood Tides of Lh’owon,” is a 20-level scenario sporting new textures, weapons, and aliens. More than that, the scenario sheds a surprising new light on the story’s characters and the meaning of events. Having defeated the Pfhor and reawakened the ancient remnants of the S’pht, the player now faces a world where friends become enemies and all is not what it seems…

      Marathon Infinity is the most popular Marathon game in online play, and is compatible with hundreds of community-made maps. This release includes the classic graphics, and revamped high-definition textures and weapons.
    '';
    homepage = "https://alephone.lhowon.org/games/infinity.html";
  };

}
