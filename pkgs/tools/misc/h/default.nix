{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
}:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    rev = "v${version}";
    hash = "sha256-eitUKOo2c1c+SyctkUW/SUb2RCKUoU6nJplfJVdwBSs=";
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
