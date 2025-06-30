{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  tcllib,
  nix-update-script,
}:

mkTclDerivation rec {
  pname = "zesty";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "nico-robert";
    repo = "zesty";
    tag = "v${version}";
    hash = "sha256-XJdgS1Lf5B5VjGq2gztc5p3E7TLiibaYfU9f8r1wKOc=";
  };

  propagatedBuildInputs = [
    tcllib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib/zesty/ *.tcl

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tcl library for rich terminal output";
    homepage = "https://github.com/nico-robert/zesty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
}
