{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "android-udev-rules-20150301";

  src = fetchgit {
    url = "https://github.com/M0Rf30/android-udev-rules";
    rev = "2cc51a456ccfbca338c4e6b76211645aaac631e9";
    sha256 = "dbf1614cebb466d1adbcc5f17cefc0c37f148f9e3b46443b3e82f6cd19a1514f";
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
