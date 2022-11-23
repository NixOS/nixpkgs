{ lib
, python3
, fetchFromGitHub
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "searxng";
  version = "unstable-2023-01-15";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "13b0c251c45c3d14700723b25b601be56178e8df";
    sha256 = "sha256-f6RKVarW3iSkDP++MdkRt1QAdnHX/fxcD2GMvQt3hnA=";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
    sed -i 's/fasttext-predict/fasttext/' requirements.txt
  '';

  preBuild = ''
    export SEARX_DEBUG="true";
  '';

  propagatedBuildInputs = with python3.pkgs; [
    babel
    certifi
    python-dateutil
    flask
    flaskbabel
    brotli
    jinja2
    langdetect
    lxml
    pygments
    pyyaml
    redis
    uvloop
    setproctitle
    httpx
    httpx-socks
    markdown-it-py
    fasttext
    pybind11
  ] ++ httpx.optional-dependencies.http2
  ++ httpx-socks.optional-dependencies.asyncio;

  passthru.updateScript = unstableGitUpdater { url = src.meta.homepage; };

  # tests try to connect to network
  doCheck = false;

  postInstall = ''
    # Create a symlink for easier access to static data
    mkdir -p $out/share
    ln -s ../${python3.sitePackages}/searx/static $out/share/
  '';

  meta = with lib; {
    homepage = "https://docs.searxng.org/";
    description = "A fork of Searx, a privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kranzes ];
  };
}
