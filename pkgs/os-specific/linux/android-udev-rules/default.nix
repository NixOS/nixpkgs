{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "android-udev-rules-20150920";

  src = fetchgit {
    url = "https://github.com/M0Rf30/android-udev-rules";
    rev = "d2e89a3f6deb096071b15e18b9e3608a02d62437";
    sha256 = "bdc553a1eb4efc4e85866f61f50f2c2f7b8d09d2eb5122afad7c9b38e0fdc4fb";
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
