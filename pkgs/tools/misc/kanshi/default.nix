{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, udev }:
rustPlatform.buildRustPackage 
{
  pname = "kanshi-unstable";
  version = "2019-02-02";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "kanshi";
    rev = "970267e400c21a6bb51a1c80a0aadfd1e6660a7b";
    sha256 = "10lfdan86bmwazpma6ixnv46z9cnf879gxln8gx87v7a1x3ss0bh";
  };

  buildInputs = [ pkgconfig udev ];

  cargoSha256 = "sha256:0lf1zfmq9ypxk86ma0n4nczbklmjs631wdzfx4wd3cvhghyr8nkq";

  meta = {
    description = "Dynamic display configuration tool";
    longDescription = 
    ''
    Kanshi uses a configuration file and a list of available displays to choose 
    the right settings for each display. It's useful if your window manager 
    doesn't support multiple display configurations (e.g. i3/Sway).
    
    For now, it only supports:
    - sysfs as backend
    - udev as notifier (optional)
    - Configuration file
      - GNOME (~/.config/monitors.xml)
      - Kanshi (see below)
    - Sway as frontend
    '';
    homepage = "https://github.com/emersion/kanshi";
    downloadPage = "https://github.com/emersion/kanshi";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.balsoft ];
    platforms = stdenv.lib.platforms.linux;
  };
}
