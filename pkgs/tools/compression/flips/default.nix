{ lib, stdenv, fetchFromGitHub, gtk3, libdivsufsort, pkg-config, wrapGAppsHook }:

stdenv.mkDerivation {
  pname = "flips";
  version = "unstable-2021-05-18";

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
    rev = "3476e5e46fc6f10df475f0cad1714358ba04c756";
    sha256 = "0s13qrmqfmlb2vy0smpgw39vjkl8vzsmpzk52jnc9r7b4hisii39";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ gtk3 libdivsufsort ];
  patches = [ ./use-system-libdivsufsort.patch ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildPhase = ''
    runHook preBuild
    ./make.sh
    runHook postBuild
  '';

  meta = with lib; {
    description = "A patcher for IPS and BPS files";
    homepage = "https://github.com/Alcaro/Flips";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.xfix ];
    platforms = platforms.linux;
  };
}
