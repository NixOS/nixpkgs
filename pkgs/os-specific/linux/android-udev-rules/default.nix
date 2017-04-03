{ stdenv, fetchFromGitHub }:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.android-udev-rules ];

stdenv.mkDerivation rec {
  name = "android-udev-rules-${version}";
  version = "20170305";

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = version;
    sha256 = "0di64pqs0snbfmncbarvyb9dr3bpv203pqxn5h5i39400jvqwyb6";
  };

  installPhase = ''
    install -D 51-android.rules $out/lib/udev/rules.d/51-android.rules
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/M0Rf30/android-udev-rules";
    description = "Android udev rules list aimed to be the most comprehensive on the net";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
