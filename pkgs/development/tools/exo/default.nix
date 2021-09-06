{ lib, stdenv, nodejs-16_x, buildGoModule, fetchFromGitHub, esbuild }:

let
  nodejs = nodejs-16_x;
  esbuild-exo = esbuild.overrideAttrs (old: {
    version = "0.12.15";  # this version needs to match the one defined in node-packages.nix
    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${version}";
      sha256 = "0d3ppyciklrq0jh2d1rjawcnmq3zba38yzbaml8d08rh3687qjr2";
    };
  });
  version = "2021.09.09";
  src = fetchFromGitHub {
    owner = "deref";
    repo = "exo";
    rev = "v${version}";
    sha256 = "09cpclinjmjppg71fdn0n38m9hyrzz6sxflcjiz3aywhz9rdwmlq";
  };
  # frontend generated with:
  # `node2nix -d -i package.json -l package-lock.json --include-peer-dependencies`
  # in https://github.com/deref/exo/tree/main/gui
  nodeDependencies = (import ./frontend.nix {
    nodejs = nodejs;
  }).nodeDependencies.override (old: {
    src = "${src}/gui";
    npmFlags = "--ignore-scripts";  # esbuild has a postinstall script that tries to install the native esbuild binary
    dontNpmInstall = true;  # otherwise we get some permission error over package-lock.json for some reason, dunno what npm tries to do
  });
  exo-gui = stdenv.mkDerivation {
    name = "exo-gui";
    inherit src;
    buildInputs = [nodejs];
    buildPhase = ''
      echo "frontend buildPhase!"
      cp -R ${nodeDependencies}/lib/node_modules ./gui/node_modules
      chmod -R +w ./gui/node_modules
      cp ${esbuild-exo}/bin/esbuild ./gui/node_modules/esbuild/bin/esbuild
      export PATH="${nodeDependencies}/bin:$PATH"

      cd gui
      npm run build
      cp -r dist $out/
    '';
    dontInstall = true;
  };
in
buildGoModule {
  pname = "exo-procman";

  inherit src;
  inherit version;

  vendorSha256 = "1g1wi8cx18xg49mnsf87czjpkz8xklvhgp4z0b08q04v9lcdzzcf";

  preBuild = ''
    # can't symlink, apparently golang doesn't support it?
    # "cannot embed directory dist/assets: in non-directory dist"
    cp -R ${exo-gui} ./gui/dist
  '';

  # Tags mentioned in https://github.com/deref/exo/issues/299#issuecomment-913942806
  tags = [
    "managed"
    "bundle"
  ];

  subPackages = [
    "cmd/exo"
  ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Development environment process manager and log viewer";
    homepage = "https://exo.deref.io/";
    license = licenses.unfree;  # https://github.com/deref/exo/issues/299#issuecomment-913942806
    maintainers = with maintainers; [ mausch ];
  };
}
