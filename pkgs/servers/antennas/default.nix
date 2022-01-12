{ lib, mkYarnPackage, fetchFromGitHub, nodejs }:

mkYarnPackage rec {
  pname = "antennas";
  version = "unstable-2021-01-21";

  src = fetchFromGitHub {
    owner = "TheJF";
    repo = "antennas";
    rev = "5e1f7375004001255e3daef7d48f45af321c7a52";
    sha256 = "0bahn4y0chk70x822nn32ya7kmn9x15jb80xa544y501x1s7w981";
  };

  preFixup = ''
    mkdir -p $out/bin
    chmod a+x $out/libexec/antennas/deps/antennas/index.js
    sed -i '1i#!${nodejs}/bin/node' $out/libexec/antennas/deps/antennas/index.js
    ln -s $out/libexec/antennas/deps/antennas/index.js $out/bin/antennas
  '';

  # The --production flag disables the devDependencies.
  yarnFlags = [ "--offline" "--production" ];
  yarnLock = ./yarn.lock;
  packageJSON = ./package.json;
  yarnNix = ./yarn.nix;

  meta = with lib; {
    description = "HDHomeRun emulator for Plex DVR to connect to Tvheadend. ";
    homepage = "https://github.com/TheJF/antennas";
    license = licenses.mit;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.unix;
  };
}
