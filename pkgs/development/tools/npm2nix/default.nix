{ stdenv, lib, fetchFromGitHub, nodejs }:

stdenv.mkDerivation rec {
  version = "6.0.0";
  name = "npm2nix-${version}";

  src = fetchFromGitHub {
    owner = "svanderburg";
    repo = "npm2nix";

    rev = "758b286acfb077051a17aa9579adc558deeebbd4";
    sha256 = "0gmvpxvp75fqw7w7x0c1ywc1zghd1hl6iimbv4xnjwlxgh704yg6";
  };

  meta = with lib; {
    description = "Generate nix expressions to build npm packages";
    homepage = http://github.com/svanderburg/npm2nix/tree/reengineering2;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.gilligan ];
  };

  buildInputs = [ nodejs ];

  buildPhase = ''
    mkdir ./npm-home
    export HOME=$(readlink -f ./npm-home)
    npm install
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp -R node_modules $out
    cp bin/npm2nix.js $out/bin/npm2nix
    cp -R lib $out/
    cp -R nix $out/

    chmod +x $out/bin/npm2nix
  '';
}
