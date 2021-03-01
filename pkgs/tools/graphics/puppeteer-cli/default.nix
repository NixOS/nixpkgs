{ fetchFromGitHub, makeWrapper, chromium, mkYarnPackage
}:

mkYarnPackage rec {
  pname = "puppeteer-cli";
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "JarvusInnovations";
    repo = "puppeteer-cli";
    rev = "v${version}";
    sha256 = "0xrb8r4qc9ds7wmfd30nslnkqylxqfwr4gqf7b30v651sjyds29x";
  };
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/puppeteer \
      --set PUPPETEER_EXECUTABLE_PATH ${chromium}/bin/chromium
  '';
}
