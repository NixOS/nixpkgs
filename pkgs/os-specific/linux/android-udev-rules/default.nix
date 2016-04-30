{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "android-udev-rules-${version}";
  version = "2016-04-26";

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = "9af6e552016392db35191142b599a5199cf8a9fa";
    sha256 = "1lvh7md6qz91q8jy9phnfxlb19s104lvsk75a5r07d8bjc4w9pxb";
  };

  installPhase = ''
    install -D 51-android.rules $out/lib/udev/rules.d/51-android.rules
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/M0Rf30/android-udev-rules;
    description = "Android udev rules list aimed to be the most comprehensive on the net";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
