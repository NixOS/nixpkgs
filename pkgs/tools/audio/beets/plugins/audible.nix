{ lib
, fetchFromGitHub
, beets
, beetsPackages
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

  prePatch = ''
      substituteInPlace pyproject.toml --replace 'markdownify = "0.11.6"' 'markdownify = "0.12.1"'
      substituteInPlace pyproject.toml --replace 'natsort = "8.2.0"' 'natsort = "8.4.0"'
  '';

  postPatch = ''
    rm test-requirements.txt
  '';

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [ pbr ];

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
