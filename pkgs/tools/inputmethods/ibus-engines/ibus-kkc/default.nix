{ stdenv, fetchFromGitHub
, vala, intltool, pkgconfig
, libkkc, ibus, skk-dicts
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "ibus-kkc";
  version = "1.5.22";

  src = fetchFromGitHub {
    owner = "ueno";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w5dpska0ps3jwqnhvxic7lmhlba2vyj85nkfngj84b9agpf7f3r";
  };

  nativeBuildInputs = [
    vala intltool pkgconfig
  ];

  buildInputs = [ libkkc ibus skk-dicts gtk3 ];

  postInstall = ''
    ln -s ${skk-dicts}/share $out/share/skk
  '';

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "libkkc (Japanese Kana Kanji input method) engine for ibus";
    homepage     = https://github.com/ueno/ibus-kkc;
    license      = licenses.gpl2;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ vanzef ];
  };
}
