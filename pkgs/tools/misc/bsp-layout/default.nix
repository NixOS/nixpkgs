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
  version = "unstable-2021-05-10";

  src = fetchFromGitHub {
    owner = "phenax";
    repo = pname;
    rev = "726b850b79eabdc6f4d236cff52e434848cb55e3";
    sha256 = "1wqlzbz7l9vz37gin2zckrnxkkabnd7x5mi9pb0x96w4yhld5mx6";
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
    maintainers = with maintainers; [ devins2518 totoroot ];
    platforms = platforms.linux;
  };
}
