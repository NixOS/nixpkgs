{ stdenv, fetchFromGitHub, coreutils }:

stdenv.mkDerivation rec {
  name = "brightnessctl-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Hummer12007";
    repo = "brightnessctl";
    rev = "${version}";
    sha256 = "0amxhcikcgj04z81272kz35m5h5q4jx9x7v71h8yl1rv4b2lzh7z";
  };

  makeFlags = [ "MODE=0755" "PREFIX=" "DESTDIR=$(out)" ];
  installTargets = [ "install" "install_udev_rules" ];

  postPatch = ''
    substituteInPlace 90-brightnessctl.rules --replace /bin/ ${coreutils}/bin/
    substituteInPlace 90-brightnessctl.rules --replace %k '*'
  '';

  meta = {
    homepage = "https://github.com/Hummer12007/brightnessctl";
    maintainers = [ stdenv.lib.maintainers.Dje4321 ];
    license = stdenv.lib.licenses.mit;
    description = "This program allows you read and control device brightness";
    platforms = stdenv.lib.platforms.linux;
  };

}
