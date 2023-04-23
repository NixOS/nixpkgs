{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "searxng";
  version = "unstable-2023-03-13";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "295c87a926c3deb1e438234550a9d8fbbaad17fa";
    sha256 = "sha256-ItPFUyyuctx/yyMVUn5Ez9f+taNiV6FR0q9wz1jwk8M=";
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
  '';

  meta = with lib; {
    homepage = "https://github.com/searxng/searxng";
    description = "A fork of Searx, a privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
