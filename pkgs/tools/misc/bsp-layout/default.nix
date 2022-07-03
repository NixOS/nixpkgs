{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, git
, bc
, bspwm
}:

stdenv.mkDerivation rec {
  pname = "bsp-layout";
  version = "unstable-2022-06-19";

  src = fetchFromGitHub {
    owner = "phenax";
    repo = pname;
    rev = "181d38443778e81df2d4bc3639063c3ae608f9c7";
    sha256 = "sha256-4NKI+OnOTYGaJnaPvSoXGJdSSzMo9AjYRLOomp9onoo=";
  };

  nativeBuildInputs = [ makeWrapper git bc ];
  buildInputs = [ bspwm ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    substituteInPlace $out/lib/bsp-layout/layout.sh --replace 'bc ' '${bc}/bin/bc '
    for layout in tall rtall wide rwide
    do
      substituteInPlace "$out/lib/bsp-layout/layouts/$layout.sh" --replace 'bc ' '${bc}/bin/bc '
    done
  '';

  meta = with lib; {
    description = "Manage layouts in bspwm";
    longDescription = ''
      bsp-layout is a dynamic layout manager for bspwm, written in bash.
      It provides layout options to fit most workflows.
    '';
    homepage = "https://github.com/phenax/bsp-layout";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
    platforms = platforms.linux;
  };
}
