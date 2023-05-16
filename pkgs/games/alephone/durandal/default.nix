{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "durandal";
  desktopName = "Marathon-Durandal";
<<<<<<< HEAD
  version = "20230119";
=======
  version = "20150620";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  icon = alephone.icons + "/marathon2.png";

  zip = fetchurl {
    url =
      "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${version}/Marathon2-${version}-Data.zip";
<<<<<<< HEAD
    sha256 = "sha256-Vbfk5wLgvNEZW2BohMY5mPXaRbNlHxJdWLYTsE8CSwI=";
=======
    sha256 = "1gpg0dk3z8irvdkm4nj71v14lqx77109chqr2ly594jqf6j9wwqv";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = {
    description = "Second chapter of the Marathon trilogy";
    longDescription = ''
      Fresh from your triumph on the starship Marathon, you are seized by the rogue computer Durandal to do his bidding in a distant part of the galaxy. Within the ruins of an ancient civilization, you must seek the remnants of a lost clan and uncover their long-buried secrets. Battle opponents ancient and terrible, with sophisticated weapons and devious strategies, all the while struggling to escape the alien nightmare…

      This release of Marathon 2: Durandal includes the classic graphics, and revamped high-definition textures and monsters from the Xbox Live Arcade edition.
<<<<<<< HEAD
    '';
=======
          '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://alephone.lhowon.org/games/marathon2.html";
  };

}
