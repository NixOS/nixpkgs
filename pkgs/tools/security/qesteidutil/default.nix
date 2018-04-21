{ stdenv, fetchFromGitHub, fetchpatch
, cmake, ccid, qttools, qttranslations
, pkgconfig, pcsclite, hicolor-icon-theme 
}:

stdenv.mkDerivation rec {

  version = "3.12.10";
  name = "qesteidutil-${version}";

  src = fetchFromGitHub {
    owner = "open-eid";
    repo = "qesteidutil";
    # TODO: Switch back to this after next release.
    #rev = "v${version}";
    # We require the remove breakpad stuff
    rev = "efdfe4c5521f68f206569e71e292a664bb9f46aa";
    sha256 = "0zly83sdqsf9lxnfw4ir2a9vmmfba181rhsrz61ga2zzpm2wf0f0";
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
    maintainers = [ maintainers.jagajaga ];
  };
}
