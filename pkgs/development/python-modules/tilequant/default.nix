{ lib, buildPythonPackage, fetchFromGitHub, GitPython, click, ordered-set, pillow, sortedcollections }:

let
  aikku93-tilequant = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "aikku93-tilequant";
    rev = "6604e0906edff384b6c8d4cde03e6601731f66fd";
    sha256 = "0w19h3n2i0xriqsy0b0rifjgbv4hqd7gl78fw0cappkrdykij5r1";
  };
in
buildPythonPackage rec {
  pname = "tilequant";
  version = "0.4.0.post0";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "189af203iay3inj1bbgm3hh1fshn879bcm28ypbvfp27fy7j5b25";
  };

  postPatch = ''
    cp -R --no-preserve=mode ${aikku93-tilequant} __aikku93_tilequant
  '';

  buildInputs = [ GitPython ];
  propagatedBuildInputs = [ click ordered-set pillow sortedcollections ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_tilequant" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/tilequant";
    description = "Tool for quantizing image colors using tile-based palette restrictions";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
