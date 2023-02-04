{ lib, stdenv, python3, chromium, xvfb-run, xorgserver, makeWrapper, chromedriver, fetchFromGitHub }:

let
  python_env = python3.withPackages
    (p: with p; [ bottle waitress selenium func-timeout requests websockets xvfbwrapper webtest ]);
in
stdenv.mkDerivation rec {
  pname = "flaresolverr";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zpeJf1CaQ4bsncZz44sH+tFKddYrZf7YdNYL50d9GA4=";
  };

  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ chromedriver ];
  patches = [ ./chromedriver_path.patch ];

  postPatch = ''
    substituteInPlace src/utils.py \
    --replace "NIX_STORE_DRIVER_PATH" "${chromedriver}/bin/chromedriver"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r src $out/share
    cp package.json $out/share
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${python_env}/bin/python $out/bin/flaresolverr \
      --prefix PATH : ${lib.makeBinPath [ chromium xvfb-run xorgserver chromedriver ]} \
      --add-flags $out/share/src/flaresolverr.py \
      --chdir $out/share/
  '';

  meta = with lib; {
    description = "Proxy server to bypass Cloudflare protection";
    homepage = "https://github.com/FlareSolverr/FlareSolverr";
    license = licenses.mit;
    maintainers = with maintainers; [ julienmalka ];
    # Flaresolverr will not run without chromedriver and xvfb-run
    platforms = lib.intersectLists chromedriver.meta.platforms xvfb-run.meta.platforms;
  };
}
