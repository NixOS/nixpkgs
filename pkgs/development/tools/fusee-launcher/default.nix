{ lib, stdenv
, python3Packages
, python3
, fetchFromGitHub
, pkgsCross
, makeWrapper
} :

let
  arm-embedded-cc = pkgsCross.arm-embedded.buildPackages.gcc;
in

stdenv.mkDerivation {
  pname = "fusee-launcher";
  version = "unstable-2018-07-14";

  src = fetchFromGitHub {
    owner = "Cease-and-DeSwitch";
    repo = "fusee-launcher";
    rev = "265e8f3e1987751ec41db6f1946d132b296aba43";
    sha256 = "1pqkgw5bk0xcz9x7pc1f0r0b9nsc8jnnvcs1315d8ml8mx23fshm";
  };

  makeFlags = [
    "CROSS_COMPILE=${arm-embedded-cc.targetPrefix}"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp fusee-launcher.py $out/bin/fusee-launcher
    cp intermezzo.bin $out/share/intermezzo.bin

    # Wrap with path to intermezzo.bin relocator binary in /share
    wrapProgram $out/bin/fusee-launcher \
      --add-flags "--relocator $out/share/intermezzo.bin" \
      --prefix PYTHONPATH : "$PYTHONPATH:$(toPythonPath $out)"
  '';

  nativeBuildInputs = [ arm-embedded-cc makeWrapper python3Packages.wrapPython ];
  buildInputs = [ python3 python3Packages.pyusb ];
  pythonPath = with python3Packages; [ pyusb ];

  meta = with lib; {
    homepage = "https://github.com/Cease-and-DeSwitch/fusee-launcher";
    description = "Work-in-progress launcher for one of the Tegra X1 bootROM exploits";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pneumaticat ];
  };

}
