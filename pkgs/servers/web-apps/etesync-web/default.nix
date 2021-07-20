{ lib
, mkYarnPackage
, fetchFromGitHub
, defaultServer ? null
}:

mkYarnPackage rec {
  pname = "etesync-web";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etesync-web";
    rev = "v${version}";
    sha256 = "iUNJbY0ImgGPSzcUnUv0yJccBeuaNaBwDwenEqjXyYs=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  dontStrip = true;

  buildPhase = lib.optionalString (defaultServer != null) ''
    REACT_APP_DEFAULT_API_PATH="${defaultServer}" \
  '' + ''
    yarn build
  '';

  meta = with lib; {
    homepage = "https://www.etesync.com/";
    description = "The EteSync Web App - Use EteSync from the browser!";
    maintainers = with maintainers; [ pacman99 ];
    license = licenses.agpl3Only;
  };
}
