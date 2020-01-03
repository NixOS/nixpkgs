{ stdenv, fetchFromGitHub, substituteAll }:

stdenv.mkDerivation rec {
  pname = "srt-to-vtt-cl";
  version = "unstable-2019-01-03";

  src = fetchFromGitHub {
    owner = "nwoltman";
    repo = pname;
    rev = "ce3d0776906eb847c129d99a85077b5082f74724";
    sha256 = "0qxysj08gjr6npyvg148llmwmjl2n9cyqjllfnf3gxb841dy370n";
  };

  patches = [
    (substituteAll {
      src = ./fix-validation.patch;
    })
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/$(uname -s)/$(uname -m)/srt-vtt $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Convert SRT files to VTT";
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo ];
    homepage = https://github.com/nwoltman/srt-to-vtt-cl;
    platforms = platforms.linux;
  };
}
