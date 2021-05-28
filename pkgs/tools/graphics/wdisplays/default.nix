{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, gtk3, epoxy, wayland, wrapGAppsHook
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "wdisplays";
  version = "1.0";

  nativeBuildInputs = [ meson ninja pkgconfig wrapGAppsHook ];

  buildInputs = [ gtk3 epoxy wayland ];

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = "wdisplays";
    rev = version;
    sha256 = "1xhgrcihja2i7yg54ghbwr1v6kf8jnsfcp364yb97vkxskc4y21y";
  };

  patches = [
    # Fixes `Gdk-Message: 10:26:38.752: Error reading events from display: Success`
    # https://github.com/cyclopsian/wdisplays/pull/20
    (fetchpatch {
      url = "https://github.com/cyclopsian/wdisplays/commit/5198a9c94b40ff157c284df413be5402f1b75118.patch";
      sha256 = "1xwphyn0ksf8isy9dz3mfdhmsz4jv02870qz5615zs7aqqfcwn85";
    })
  ];

  meta = let inherit (stdenv) lib; in {
    description = "A graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/cyclopsian/wdisplays";
    maintainers = with lib.maintainers; [ lheckemann ma27 ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
