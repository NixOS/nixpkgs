{ lib, stdenv, fetchFromGitHub }:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.qmk-udev-rules ];

stdenv.mkDerivation rec {
  pname = "qmk-udev-rules";
  version = "0.13.23";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_firmware";
    rev = version;
    sha256 = "08d2ri9g6lky3ixd5h0scm95hgc52lcjr3vcnmpdxn780q9ygmkm";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D util/udev/50-qmk.rules $out/lib/udev/rules.d/50-qmk.rules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/qmk/qmk_firmware";
    description = "Official QMK udev rules list";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ekleog ];
  };
}
