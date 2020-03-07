{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, gtk3, epoxy, wayland }:
stdenv.mkDerivation {
  pname = "wdisplays-unstable";
  version = "2020-01-12";

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ gtk3 epoxy wayland ];

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = "wdisplays";
    rev = "ba331cab535318888a562f5a2731d2523b310dac";
    sha256 = "0fk3l78hirxdi74iqmq6mxi9daqnxdkbb5a2wfshmr11ic9xixpm";
  };

  meta = let inherit (stdenv) lib; in {
    description = "A graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/cyclopsian/wdisplays";
    maintainers = with lib.maintainers; [ lheckemann ma27 ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
