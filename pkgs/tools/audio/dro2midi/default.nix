{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dro2midi";
  version = "1.6";

  src = fetchFromGitHub {
    repo = name;
    owner = "Malvineous";
    rev = "v${version}";
    sha256 = "0yxr6rhyrlxv18175ipbr4z4fr90djm7ily9m607fmjgfwn5ldl6";
  };

  doCheck = true;

  buildPhase = ''
    ./make
  '';

  checkPhase = ''
    substituteInPlace verify.sh \
      --replace /tmp . \
      --replace "wine ./dro2midi.exe" ./dro2midi \
      --replace exit "exit 1"

    ./verify.sh
  '';

  installPhase = ''
    install -Dm755 dro2midi $out/bin/dro2midi
    mkdir -p $out/share/dro2midi
    install -Dm644 *.txt $out/share/dro2midi
  '';

  meta = with stdenv.lib; {
    homepage = http://www.shikadi.net/utils/dro2midi;
    description = "Convert DRO files into MIDI and SBI instrument files";
    license = "non-commercial";
    maintainers = with maintainers; [ gnidorah ];
    platforms = platforms.linux;
  };
}
