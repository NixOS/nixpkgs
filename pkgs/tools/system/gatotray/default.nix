{ stdenv, lib, pkg-config, gdk-pixbuf, gtk2, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gatotray";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "gatopeich";
    repo = "gatotray";
    rev = "v${version}";
    sha256 = "08hy1zyq0nkrhmp599x6k0sn93a4484yi2lfgl0xf25lwdsrsyr5";
  };

  # Fix https://github.com/gatopeich/gatotray/issues/4 for latest stable version
  patches = [ ./0001-Fix-issue-4-free-invalid-pointer.patch ];

  postPatch = ''
    # Substitute hard-coded install destinations
    substituteInPlace Makefile \
      --replace /usr/local/bin $out/bin \
      --replace /usr/share/ $out/share/

    # Leave stripping to fixup phase
    sed -i "/strip/d" Makefile
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gdk-pixbuf gtk2 ];

  dontConfigure = true;

  preInstall = ''
    mkdir -p $out/bin $out/share/applications $out/share/icons
  '';

  meta = with lib; {
    description = "A lightweight graphical system tray CPU monitor";
    homepage = "https://github.com/gatopeich/gatotray";
    license = licenses.cc-by-30;
    maintainers = [ maintainers.timor ];
    platforms = platforms.linux;
  };
}
