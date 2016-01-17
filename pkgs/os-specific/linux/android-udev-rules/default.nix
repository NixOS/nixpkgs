{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "android-udev-rules-20151209";

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = "b22717d2337f991787ab687f6d0258207c6ad288";
    sha256 = "1z03nlqj68bxs163jmn66j3n0ywwar5bihpsz5ag8ak3nn2d3fp2";
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
