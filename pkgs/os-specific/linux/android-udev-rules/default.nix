{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "android-udev-rules-20150821";

  src = fetchgit {
    url = "https://github.com/M0Rf30/android-udev-rules";
    rev = "07ccded2a89c2bb6da984e596c015c5e9546e497";
    sha256 = "953fc10bd0de46afef999dc1c1b20801b3d6e289af48d18fa96b1cac3ac54518";
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
