{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonPackage {
  pname = "spotify-backup";
  version = "0-unstable-2023-02-24";

  src = fetchFromGitHub {
    owner = "caseychu";
    repo = "spotify-backup";
    rev = "0ccf12c9c7a399c6a08a38366ee02151ea04369b";
    hash = "sha256-+z9IWgtc71GPPLDqNU4PXFDyD5Dczp3Bbrwzy/DaIts=";
  };

  preBuild = ''
    cat > setup.py << EOF
from setuptools import setup
setup(scripts=['spotify-backup.py'])
EOF'';

  postInstall = ''
    mv -v $out/bin/spotify-backup.py $out/bin/spotify-backup
  '';

  meta = with lib; {
    description = "A Python script that exports all of your Spotify playlists";
    homepage = "https://github.com/caseychu/spotify-backup";
    license = licenses.mit;
    mainProgram = "spotify-backup";
  };
}

