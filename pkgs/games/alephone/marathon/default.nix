{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon";
  desktopName = "Marathon";
  version = "20210408";
  icon = alephone.icons + "/marathon.png";

  zip = fetchurl {
    url = "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${version}/Marathon-${version}-Data.zip";
    sha256 = "sha256-WM5c0X/BGeDu8d7hME3LiZavkgJll6rc3Beat/2bsdg=";
  };

  meta = {
    description = "First chapter of the Marathon trilogy";
    longDescription = ''
      Alien forces have boarded the interstellar colony ship Marathon. The situation is dire. As a security officer onboard, it is your duty to defend the ship and its crew.

      Experience the start of Bungie’s iconic trilogy with Marathon. This release uses the original Marathon data files for the most authentic experience outside of a classic Mac or emulator.
    '';
    homepage = "https://alephone.lhowon.org/games/marathon.html";
  };

}
