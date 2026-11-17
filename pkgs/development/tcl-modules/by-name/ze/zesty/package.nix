{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  tcllib,
  nix-update-script,
}:

mkTclDerivation (finalAttrs: {
  pname = "zesty";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "nico-robert";
    repo = "zesty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TT6NXE2gNVoXrlVONvndrAkoUKH3kEZbuE9ncR37itc=";
  };

  propagatedBuildInputs = [
    tcllib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib/zesty/ *.tcl
    cp -r src $out/lib/zesty/src
    install -Dm644 -t $out/doc/zesty/examples/ examples/*.tcl

    runHook postInstall
  '';

  tclRequiresCheck = [ "zesty" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tcl library for rich terminal output";
    homepage = "https://github.com/nico-robert/zesty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
