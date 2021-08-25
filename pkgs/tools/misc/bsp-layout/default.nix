{ stdenv, fetchFromGitHub, lib, bspwm, makeWrapper, git, bc }:

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
    substituteInPlace $out/bin/bsp-layout --replace 'bc ' '${bc}/bin/bc '
  '';

  meta = with lib; {
    description = "Manage layouts in bspwm";
    homepage = "https://github.com/phenax/bsp-layout";
    license = licenses.mit;
    maintainers = with maintainers; [ devins2518 ];
    platforms = platforms.linux;
  };
}
