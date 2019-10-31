{ stdenv, fetchFromGitHub
, cmake, ccid, qttools, qttranslations
, pkgconfig, pcsclite, hicolor-icon-theme 
}:

stdenv.mkDerivation {
  version = "2018-08-21";
  pname = "qesteidutil";

  src = fetchFromGitHub {
    owner = "open-eid";
    repo = "qesteidutil";
    # TODO: Switch back to this after next release.
    #rev = "v${version}";
    rev = "3bb65ef345aaa0d589b37a5d0d6f5772e95b0cd7";
    sha256 = "13xsw5gh4svp9a5nxcqv72mymivr7w1cyjbv2l6yf96m45bsd9x4";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ccid qttools pcsclite qttranslations
                  hicolor-icon-theme
                ];
  
  meta = with stdenv.lib; {
    description = "UI application for managing smart card PIN/PUK codes and certificates";
    homepage = http://www.id.ee/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jagajaga domenkozar ];
  };
}
