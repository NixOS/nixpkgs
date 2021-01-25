{ lib, python3, fetchFromGitHub, nodejs, nodePackages }:

with python3.pkgs;

buildPythonApplication rec {
  disabled = isPy27;

  pname = "hindsight";
  version = "2021.01.16";

  src = fetchFromGitHub {
    owner = "obsidianforensics";
    repo = pname;
    rev = version;
    sha256 = "0ibvwm36lfqfrm8h542v9fdf74czbf6rfajrcdmk1gwxv4d5nxa7";
  };

  nativeBuildInputs = [ nodejs ] ++ (with nodePackages; [
    esinstall
    sqlite-view
    terser
  ]);

  propagatedBuildInputs = [
    bottle
    keyring
    puremagic
    pycryptodomex
    pytz
    XlsxWriter
  ];

  checkInputs = [
    pytest
  ];

  postPatch = ''
    patchShebangs ./install-js.sh

    # Symlink dependencies, per advice: https://nodejs.org/api/esm.html#esm_no_node_path.
    mkdir -p node_modules
    for path in $(echo $NODE_PATH | tr ':' '\n'); do
      ln -s $path/* node_modules/
    done

    # Don't exclude the javascript assets we're building.
    substituteInPlace MANIFEST.in --replace "recursive-exclude pyhindsight/static/web_modules *" ""
  '';

  preBuild = ''
    ./install-js.sh --no-http
  '';

  checkPhase = ''
    # XXX Upstream's tests are currently broken.
    # pytest

    if [[ ! -d $out/${python.sitePackages}/pyhindsight/static/web_modules ]]; then
      echo "Javascript was not installed successfully."
      exit 1
    fi
  '';

  meta = with lib; {
    homepage = "https://github.com/obsidianforensics/hindsight";
    description = "Web browser forensics for Google Chrome/Chromium";
    license = licenses.asl20;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
