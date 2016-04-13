{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "android-udev-rules-${version}";
  version = "2016-03-03";

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = "a6ec1239173bfbe2082211261528e834af9fbb64";
    sha256 = "11g7m8jjxxzyrbsd9g7cbk6bwy3c4f76pdy4lvdx68xrbsl2rvmj";
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
