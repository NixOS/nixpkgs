{ stdenv, fetchFromGitHub, extra-cmake-modules, kdeFrameworks, php }:
# php is for pprof2calltree

stdenv.mkDerivation rec {
  name = "kcachegrind-${version}";

  version = "2017-02-25";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kcachegrind";
    rev = "3c0f3423e58f65f93bf062b319a346dcea11daff";
    sha256 = "0qpvrkiir5yclsqxmwsbs8s6dkl9msx3nynnskrx2vf4nikxp2i1";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = with kdeFrameworks; [
    karchive kcoreaddons kdoctools ki18n kio kwidgetsaddons kxmlgui
  ] ++ [ php ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ orivej ];
  };
}
