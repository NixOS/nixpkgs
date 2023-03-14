{ lib, stdenv, fetchFromGitHub, pkg-config, hidapi }:

stdenv.mkDerivation {
  pname = "footswitch";
  version = "unstable-2022-04-12";

  src = fetchFromGitHub {
    owner = "rgerganov";
    repo = "footswitch";
    rev = "1cf63643e18e688e4ebe96451db24edf52338cc0";
    sha256 = "0gfvi2wgrljndyz889cjjh2q13994fnaf11n7hpdd82c4wgg06kj";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ hidapi ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace /usr/bin/install install \
      --replace /etc/udev $out/lib/udev
  '';

  preInstall = ''
    mkdir -p $out/bin $out/lib/udev/rules.d
  '';

  meta = with lib; {
    description = "Command line utlities for programming PCsensor and Scythe foot switches.";
    homepage    = "https://github.com/rgerganov/footswitch";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ baloo ];
  };
}
