{ stdenv, pkgs, buildChromiumExtension, fetchFromGitHub }:
with stdenv.lib;
let
  uassets = import ../../libs/uassets { inherit stdenv fetchFromGitHub; };
in
buildChromiumExtension rec {
  pname = "ublock-origin";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "gorhill";
    repo = "uBlock";
    rev = version;
    sha256 = "1z38084inkphlq3y7fkqj9gdk3xa5yj9amhqhm3saqvfrzkngzcs";
  };

  buildInputs = [
    pkgs.bash
    pkgs.python
    uassets
  ];

  patchPhase = ''
    # Fail build phase on any script failure.
    sed -i 's/^bash/bash -e -o pipefail/g' ./tools/*.sh
    # Patch in static assets from separate package.
    substituteInPlace ./tools/make-assets.sh --replace ../uAssets ${uassets}
  '';

  buildPhase = ''
    ${pkgs.bash}/bin/bash -e -o pipefail ./tools/make-chromium.sh
  '';

  preInstall = ''
    cd dist/build/uBlock0.chromium
  '';

  meta = {
    description = "An efficient blocker add-on for various browsers";
    homepage = "https://github.com/gorhill/uBlock";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
