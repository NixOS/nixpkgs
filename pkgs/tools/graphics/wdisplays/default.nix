{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, gtk3, epoxy, wayland }:

stdenv.mkDerivation rec {
  pname = "wdisplays";
  version = "1.0";

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ gtk3 epoxy wayland ];

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = "wdisplays";
    rev = version;
    sha256 = "1xhgrcihja2i7yg54ghbwr1v6kf8jnsfcp364yb97vkxskc4y21y";
  };

  meta = let inherit (stdenv) lib; in {
    description = "A graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/cyclopsian/wdisplays";
    maintainers = with lib.maintainers; [ lheckemann ma27 ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
