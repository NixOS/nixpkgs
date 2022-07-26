{ lib, stdenv, fetchFromGitHub, pkg-config, hidapi }:

stdenv.mkDerivation {
  pname = "footswitch";
  version = "unstable-20201-03-17";

  src = fetchFromGitHub {
    owner = "rgerganov";
    repo = "footswitch";
    rev = "aa0b10f00d3e76dac27b55b88c8d44c0c406f7f0";
    sha256 = "sha256-SikYiBN7jbH5I1x5wPCF+buwFp1dt35cVxAN6lWkTN0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ hidapi ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace /usr/bin/install install \
      --replace /etc/udev/rules.d $out/lib/udev/rules.d
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
