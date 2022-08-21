{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ripe-atlas-tools";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "ripe-atlas-tools";
    rev = "v${version}";
    sha256 = "sha256-5AMqBXxJZOtI0/2NrEjrUfNXWKc7sn6kZX26766LBUM=";
  };

  checkInputs = with python3.pkgs; [
    sphinx
    pytestCheckHook
  ];

  # TODO(raitobezarius): cannot import during tests ripe.atlas.cousteau/ripe.atlas.sagan, I do not know why.
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    ripe-atlas-cousteau
    ripe-atlas-sagan

    ujson

    sphinx
    sphinx_rtd_theme

    ipy
    python-dateutil
    requests
    tzlocal
    pyyaml
    pyopenssl
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "RIPE ATLAS project tools";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-tools";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
