{ lib, stdenv, fetchurl, fetchpatch
, vala, gobject-introspection, intltool, python3, glib
, pkg-config
, libgee, json-glib, marisa, libkkc-data
}:

stdenv.mkDerivation rec {
  pname = "libkkc";
  version = "0.3.5";

  src = fetchurl {
    url = "${meta.homepage}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "89b07b042dae5726d306aaa1296d1695cb75c4516f4b4879bc3781fe52f62aef";
  };

  patches = [
    (fetchpatch {
      name = "build-python3.patch";
      url = "https://github.com/ueno/libkkc/commit/ba1c1bd3eb86d887fc3689c3142732658071b5f7.patch";
      hash = "sha256-4IVpcJJFrxmxJGNiRHteleAa6trOwbvMHRTE/qyjOPY=";
    })
  ];

  nativeBuildInputs = [
    vala gobject-introspection
    python3 python3.pkgs.marisa
    intltool glib pkg-config
  ];

  buildInputs = [ marisa libkkc-data ];
  enableParallelBuilding = true;

  propagatedBuildInputs = [ libgee json-glib ];

  postInstall = ''
    ln -s ${libkkc-data}/lib/libkkc/models $out/share/libkkc/models
  '';

  meta = with lib; {
    description = "Japanese Kana Kanji conversion input method library";
    homepage    = "https://github.com/ueno/libkkc";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ vanzef ];
    platforms   = platforms.linux;
  };
}
