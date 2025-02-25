{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
}:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    rev = "v${version}";
    hash = "sha256-4rhol8a+OMX2+MxFPEM1WzM/70C7sye8jw4pg7CujRo=";
  };

  buildInputs = [ ruby ];

  installPhase = ''
    mkdir -p $out/bin
    cp h $out/bin/h
    cp up $out/bin/up
  '';

  meta = with lib; {
    description = "faster shell navigation of projects";
    homepage = "https://github.com/zimbatm/h";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
  };
}
