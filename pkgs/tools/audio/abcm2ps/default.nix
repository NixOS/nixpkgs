{ lib
, stdenv
, fetchFromGitHub
, docutils
, pkg-config
, freetype
, pango
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcm2ps";
  version = "8.14.15";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0ZSMKARX16/33sIWR8LOVOFblI/Q+iZgnfVq/xqRMnI=";
  };

  configureFlags = [
    "--INSTALL=install"
  ];

  nativeBuildInputs = [ docutils pkg-config ];

  buildInputs = [ freetype pango ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "abcm2ps -V";
    };
  };

  meta = with lib; {
    homepage = "http://moinejf.free.fr/";
    license = licenses.lgpl3Plus;
    description = "A command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
    mainProgram = "abcm2ps";
  };
})
