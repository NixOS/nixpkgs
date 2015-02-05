{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "android-udev-rules";

  src = fetchgit {
    url = "git://github.com/M0Rf30/android-udev-rules";
    rev = "82f78561f388363a925e6663211988d9527de0c6";
    sha256 = "badd7a152acf92c75335917c07125ffb1b5fda0bed5ec1e474d76e48a8d9f0db";
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
