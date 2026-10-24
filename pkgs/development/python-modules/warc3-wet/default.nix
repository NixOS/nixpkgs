{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "warc3-wet";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1Dck83Ltu8eZC5w4Skk/tggYx8muYp2Owxwpy7zNAbk=";
  };

  postPatch = ''
    substituteInPlace warc/utils.py \
      --replace "from collections import" "from collections.abc import"
  '';

  meta = with lib; {
    homepage = "https://github.com/Willian-Zhang/warc3";
    license = licenses.gpl2;
    description = "Python library to work with ARC and WARC files";
    maintainers = [ maintainers.gm6k ];
  };
}
