{ stdenv, fetchFromGitHub }:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.android-udev-rules ];

stdenv.mkDerivation rec {
  pname = "android-udev-rules";
  version = "20200613";

  src = fetchFromGitHub {
    owner = "M0Rf30";
    repo = "android-udev-rules";
    rev = version;
    sha256 = "0cf5br8x6iwxc1cifv0i1klw7skgs8hghdx6qlqby68kyqg81bb2";
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
