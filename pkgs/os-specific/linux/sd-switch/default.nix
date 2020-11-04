{ stdenv, fetchFromGitLab, rustPlatform, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "sd-switch";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "rycee";
    repo = pname;
    rev = version;
    sha256 = "1bhks4ma3sn95bsszs6lj9cwfr8zgmja0hqfp8xr5iq77ww2p6k3";
  };

  cargoSha256 = "0lskxakzh3yji0rzk8jcfz1sv4j19b5kmdsaj7401m5w84s1cbjw";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = with stdenv.lib; {
    description = "A systemd unit switcher for Home Manager";
    homepage = "https://gitlab.com/rycee/sd-switch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
