{ stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland # wayland-scanner
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wob";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "francma";
    repo = pname;
    rev = version;
    sha256 = "1z8q5p5q8f0dfjzr96jldz97ycir9ip4p2cwj26nywmb8r0hznjr";
  };

  postPatch = "sed -Ei 's/Version\ 0\.[0-9]/Version ${version}/' wob.1.scd";

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland ];
  buildInputs = [ wayland-protocols ];

  meta = with stdenv.lib; {
    description = "A lightweight overlay bar for Wayland";
    longDescription = ''
      A lightweight overlay volume/backlight/progress/anything bar for Wayland,
      inspired by xob.
    '';
    inherit (src.meta) homepage;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
