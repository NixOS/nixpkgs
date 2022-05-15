{ lib, pkgs, fetchFromGitHub, stdenv, ... }:

let
  nodejs = pkgs."nodejs-17_x";

  nodeEnv = import ./node-env.nix {
    inherit (pkgs) stdenv lib python2 runCommand writeTextFile writeShellScript;
    inherit pkgs nodejs;
    libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
  };

  globalBuildInputs = pkgs.lib.attrValues (import ./supplement.nix {
    inherit nodeEnv;
    inherit (pkgs) stdenv lib nix-gitignore fetchurl fetchgit;
  }) ++ [pkgs.python3];

  nodePackages = import ./node-packages.nix {
    inherit (pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
    inherit nodeEnv globalBuildInputs;
  };

  nodeDependencies = nodePackages.nodeDependencies.overrideAttrs (oldAttrs: rec {
    installPhase = ''
      export CHROMEDRIVER_SKIP_DOWNLOAD=true
    '' + oldAttrs.installPhase;
  });
in
pkgs.stdenv.mkDerivation {
  pname = "cyberchef";
  # Don't pull version from nodePackages.package.version because then
  # update-source-version won't know to update the sha256
  version = "9.37.3";

  src = pkgs.fetchFromGitHub {
    owner = "gchq";
    repo = "CyberChef";
    rev = "v${nodePackages.package.version}";
    sha256 = "sha256-9m644kw5FJWpSIhKd7Q5hEZNnUzJi7mg0YRamI54+uA=";
  };

  passthru.updateScript = ./update.sh;

  buildInputs = nodePackages.package.buildInputs ++ [pkgs.unzip];

  buildPhase = ''
    # The fixCryptoApiImports task represents a problem. It's normally
    # configured in package.json as a postinstall script, but unfortunately
    # that doesn't work with node2nix.
    #
    # The task requires the Gruntfile to be available, but node2nix seems to
    # build a fake environment with only minimal files (not the Gruntfile) and
    # so the postinstall script fails. Solve this problem by having generate.sh
    # remove the postinstall script from package.json, and then we instead call
    # the fixCryptoApiImports task here in this buildPhase, where the Gruntfile
    # is available.
    #
    # The last problem is that fixCryptoApiImports modifies node_modules, but
    # node2nix gives us an immutable node_modules. So instead of symlinking
    # node_modules as is done in the documentation, we copy it and set it
    # writable so that fixCryptoApiImports can patch it.

    cp -r ${nodeDependencies}/lib/node_modules ./node_modules
    chmod -R +w ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"

    npx grunt exec:fixCryptoApiImports

    npx grunt prod
  '';

  installPhase = ''
    mkdir -p $out/share/cyberchef
    unzip -d $out/share/cyberchef ./build/prod/CyberChef*.zip
    mv -v $out/share/cyberchef/CyberChef_v*.html $out/share/cyberchef/index.html
  '';

  meta = with lib; {
    description = "The Cyber Swiss Army Knife for encryption, encoding, compression and data analysis.";
    homepage = "https://gchq.github.io/CyberChef";
    maintainers = with maintainers; [ sebastianblunt ];
    license = licenses.asl20;
  };
}
