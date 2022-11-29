{ lib, fetchFromGitHub, beets, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "beets-originquery";
  version = "1.0.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "x1ppy";
    rev = version;
    hash = "sha256-32S8Ik6rzw6kx69o9G/v7rVsVzGA1qv5pHegYDmTW68=";
  };

  nativeBuildInputs = [ beets ];

  propagatedBuildInputs = with python3Packages; [
    confuse
    jsonpath_rw
    pyyaml
  ];

  meta = with lib; {
    description = "Integrate origin metadata (origin.txt) into beets' MusicBrainz queries";
    homepage = "https://github.com/x1ppy/beets-originquery";
    maintainers = with maintainers; [ somasis ];
    license = licenses.unfree; # <https://github.com/x1ppy/beets-originquery/issues/3>
    inherit (beets.meta) platforms;
  };
}
