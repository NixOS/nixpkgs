{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  tcllib,
  nix-update-script,
}:

mkTclDerivation rec {
  pname = "zesty";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "nico-robert";
    repo = "zesty";
    tag = "v${version}";
    hash = "sha256-1K3E9rQAXEXegLjp2mZTzwyDXq3lMpDr0DB4I+ACH08=";
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
