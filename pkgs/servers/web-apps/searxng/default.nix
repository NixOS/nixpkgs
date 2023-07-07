{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "searxng";
  version = "unstable-2023-06-26";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "da7c30291dcf53cc5b3d98f9aada5615cd1593a9";
    sha256 = "sha256-kbNw/YgcBZNkmn2nmsnEnc9Y8MJg3zGFdW1x9GIo+dM=";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
  '';

  preBuild = ''
    export SEARX_DEBUG="true";
  '';

  propagatedBuildInputs = with python3.pkgs; [
    babel
    certifi
    python-dateutil
    fasttext-predict
    flask
    flask-babel
    brotli
    jinja2
    lxml
    pygments
    pytomlpp
    pyyaml
    redis
    uvloop
    setproctitle
    httpx
    httpx-socks
    markdown-it-py
  ] ++ httpx.optional-dependencies.http2
  ++ httpx-socks.optional-dependencies.asyncio;

  # tests try to connect to network
  doCheck = false;

  postInstall = ''
    # Create a symlink for easier access to static data
    mkdir -p $out/share
    ln -s ../${python3.sitePackages}/searx/static $out/share/

    # copy config schema for the limiter
    cp searx/botdetection/limiter.toml $out/${python3.sitePackages}/searx/botdetection/limiter.toml
  '';

  meta = with lib; {
    homepage = "https://github.com/searxng/searxng";
    description = "A fork of Searx, a privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
