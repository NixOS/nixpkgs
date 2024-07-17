{
  lib,
  stdenv,
  fetchurl,
  vala,
  intltool,
  pkg-config,
  libkkc,
  ibus,
  skk-dicts,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "ibus-kkc";
  version = "1.5.22";

  src = fetchurl {
    url = "${meta.homepage}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1kj74c9zy9yxkjx7pz96mzqc13cf10yfmlgprr8sfd4ay192bzi2";
  };

  nativeBuildInputs = [
    vala
    intltool
    pkg-config
  ];

  buildInputs = [
    libkkc
    ibus
    skk-dicts
    gtk3
  ];

  postInstall = ''
    ln -s ${skk-dicts}/share $out/share/skk
  '';

  meta = with lib; {
    isIbusEngine = true;
    description = "libkkc (Japanese Kana Kanji input method) engine for ibus";
    homepage = "https://github.com/ueno/ibus-kkc";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vanzef ];
  };
}
