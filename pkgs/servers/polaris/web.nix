{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "polaris-web";
  version = "76";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris-web";
    tag = "build-${version}";
    hash = "sha256-mGsgW6lRqCt+K2RrF2s4zhvYzH94K+GEXGUCn5ngBTY=";
  };

  npmDepsHash = "sha256-MVqC6mMdiqtJzAB8J8xdxO5xCwiibBasA3BvN6EiBSM=";

  env.PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/polaris-web

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web client for Polaris";
    homepage = "https://github.com/agersant/polaris-web";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
