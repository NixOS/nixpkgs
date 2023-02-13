{ lib
, buildGoModule
, fetchFromSourcehut
, ffmpeg
, makeWrapper
}:

buildGoModule rec {
  pname = "unflac";
  version = "1.0";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = pname;
    rev = version;
    sha256 = "1vlwlm895mcvmxaxcid3vfji1zi9wjchz7divm096na4whj35cc4";
  };

  vendorSha256 = "sha256-QqLjz1X4uVpxhYXb/xIBwuLUhRaqwz2GDUPjBTS4ut0=";

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
