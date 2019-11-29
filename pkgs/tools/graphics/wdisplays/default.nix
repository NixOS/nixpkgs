{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, gtk3, epoxy, wayland }:
stdenv.mkDerivation {
  pname = "wdisplays";
  version = "2019-10-26-unstable";

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ gtk3 epoxy wayland ];

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = "wdisplays";
    rev = "22669edadb8ff3478bdb51ddc140ef6e61e3d9ef";
    sha256 = "127k5i98km6mh8yw4vf8n44b29kc3n0169xpkdh7yr0rhv6n9cdl";
  };

  meta = let inherit (stdenv) lib; in {
    description = "A graphical application for configuring displays in Wayland compositors";
    homepage = "https://github.com/cyclopsian/wdisplays";
    maintainers = [ lib.maintainers.lheckemann ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
