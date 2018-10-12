{ stdenv, fetchFromGitHub, pkgconfig, meson, vala, ninja
, gtk3, poppler, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "pdftag";
  name = "${pname}-${version}";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "arrufat";
    repo = pname;
    rev = "v${version}";
    sha256 = "1paj8hs27akzsivn01a30fl3zx5gfn1h89wxg2m72fd806hk0hql";
  };

  nativeBuildInputs = [ pkgconfig meson ninja wrapGAppsHook vala ];
  buildInputs = [ gtk3 poppler ];

  meta = with stdenv.lib; {
    description = "Edit metadata found in PDFs";
    license = licenses.gpl3;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.unix;
  };
}
