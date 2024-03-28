{ lib
, fetchFromGitHub
, beets
, beetsPackages
, poetry-core
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-audible";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-audible";
    owner = "Neurrone";
    rev = "v${version}";
    sha256 = "sha256-XO12iKb29az5fKI5XvO4LtPzSEsG771F5PJ1R1WBNsk=";
  };

  PBR_VERSION = version;

  propagatedBuildInputs = with python3Packages; [ pbr ];

  postPatch = ''
    rm test-requirements.txt
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    beets
    beetsPackages.copyartifacts
    python3Packages.markdownify
    python3Packages.natsort
  ];

  pythonImportsCheck = [
    "beetsplug.api"
    "beetsplug.audible"
    "beetsplug.book"
    "beetsplug.goodreads"
  ];

  meta = with lib; {
    description = "Beets plugin to manage audiobook collections";
    homepage = "https://github.com/Neurrone/beets-audible";
    maintainers = with maintainers; [ dansbandit ];
    license = licenses.mit;
    inherit (beets.meta) platforms;
  };
}
