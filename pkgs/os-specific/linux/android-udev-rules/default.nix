{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "android-udev-rules-20151108";

  src = fetchgit {
    url = "https://github.com/M0Rf30/android-udev-rules";
    rev = "3d21377820694cf8412e1fd09be5caaad3a5eef8";
    sha256 = "2f90bc5822144df916d11ff5312c3179f1b905a7b003aa86056aa24ba433c99b";
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
