{ lib
, stdenvNoCC
, patsh
, python3
, gnugrep
, zstd
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      namcap = final.callPackage ./python-module.nix { inherit zstd; };
    };
  };
  pythonEnv = python.withPackages (ps: with ps; [ namcap ]);
  module = python.pkgs.namcap;
in

stdenvNoCC.mkDerivation {
  inherit (module) src pname version;

  dontBuild = true;

  nativeBuildInputs = [ patsh ];

  buildInputs = [
    gnugrep
  ];

  postPatch = ''
    patchShebangs scripts/namcap
    substituteInPlace scripts/namcap \
      --replace /usr/bin/env\ python3 ${pythonEnv}/bin/python3
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    patsh scripts/namcap $out/bin/namcap
    chmod +x $out/bin/namcap
    ln -s ${module}/share $out/
    runHook postInstall
  '';

  passthru = {
    inherit python pythonEnv module;
  };

  meta = with lib; {
    description = "Pacman package lint tool";
    homepage = "https://gitlab.archlinux.org/pacman/namcap";
    changelog = "https://gitlab.archlinux.org/pacman/namcap/-/blob/${module.version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samlukeyes123 ];
  };
}
