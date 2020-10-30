{ stdenv, fetchFromGitHub, gtk3, libdivsufsort, pkg-config, wrapGAppsHook }:

stdenv.mkDerivation {
  pname = "flips";
  version = "unstable-2020-10-02";

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
    rev = "5a3d2012b8ea53ae777c24b8ac4edb9a6bdb9761";
    sha256 = "1ksh9j1n5z8b78yd7gjxswndsqnb1azp84xk4rc0p7zq127l0fyy";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ gtk3 libdivsufsort ];
  patches = [ ./use-system-libdivsufsort.patch ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildPhase = "./make.sh";

  meta = with stdenv.lib; {
    description = "A patcher for IPS and BPS files";
    homepage = "https://github.com/Alcaro/Flips";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.xfix ];
    platforms = platforms.linux;
  };
}
