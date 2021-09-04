{ lib, callPackage, mkYarnPackage, fetchFromGitLab, nodejs }:

mkYarnPackage rec {
  pname = "matrix-alertmanager";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "git.feneas.org";
    owner = "jaywink";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q9vrklcnlmcgj4mms3im54zbwjjb2k1q0883v8gxl8hzqykl315";
  };

  packageJSON = ./package.json;
  yarnNix = ./yarn.nix;
  yarnLock = ./yarn.lock;

  prePatch = ''
    cp ${./package.json} ./package.json
  '';
  postInstall = ''
    sed '1 s;^;#!${nodejs}/bin/node\n;' -i $out/libexec/matrix-alertmanager/node_modules/matrix-alertmanager/src/app.js
    chmod +x $out/libexec/matrix-alertmanager/node_modules/matrix-alertmanager/src/app.js
  '';

  passthru.updateScript = callPackage ./update.nix {};

  meta = with lib; {
    description = "Bot to receive Alertmanager webhook events and forward them to chosen rooms";
    homepage = "https://git.feneas.org/jaywink/matrix-alertmanager";
    maintainers = with maintainers; [ yuka ];
  };
}
