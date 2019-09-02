{ stdenv
, fetchFromGitHub
, ninja
, meson
, pkgconfig
, gthree
, gsound
, epoxy
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "gnome-hexgl";
  version = "unstable-2019-08-21";

  src = fetchFromGitHub {
    owner = "alexlarsson";
    repo = "gnome-hexgl";
    rev = "c6edde1250b830c7c8ee738905cb39abef67d4a6";
    sha256 = "17j236damqij8n4a37psvkfxbbc18yw03s3hs0qxgfhl4671wf6z";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkgconfig
  ];

  buildInputs = [
    gthree
    gsound
    epoxy
    gtk3
  ];

  meta = with stdenv.lib; {
    description = "Gthree port of HexGL";
    homepage = https://github.com/alexlarsson/gnome-hexgl;
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
