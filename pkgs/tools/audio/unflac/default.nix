{ lib
, buildGoModule
, fetchFromSourcehut
, ffmpeg
, makeWrapper
}:

buildGoModule rec {
  pname = "unflac";
<<<<<<< HEAD
  version = "1.1";
=======
  version = "1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-gDgmEEOvsudSYdLUodTuE50+2hZpMqlnaVGanv/rg+U=";
  };

  vendorHash = "sha256-X3cMhzaf1t+x7D8BVBfQy00rAACDEPmIOezIhKzqOZ8=";
=======
    sha256 = "1vlwlm895mcvmxaxcid3vfji1zi9wjchz7divm096na4whj35cc4";
  };

  vendorSha256 = "sha256-QqLjz1X4uVpxhYXb/xIBwuLUhRaqwz2GDUPjBTS4ut0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/unflac --prefix PATH : "${lib.makeBinPath [ffmpeg]}"
  '';

  meta = with lib; {
    description =
      "A command line tool for fast frame accurate audio image + cue sheet splitting";
    homepage = "https://sr.ht/~ft/unflac/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
