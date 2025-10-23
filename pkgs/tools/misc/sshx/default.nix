{
  lib,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  buildNpmPackage,
}:
let
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "sshx";
    tag = "v${version}";
    hash = "sha256-+IHV+dJb/j1/tmdqDXo6bqhvj3nBQ7i4AsUeHFA3+NU=";
  };

  mkSshxPackage =
    { pname, cargoHash, ... }@args:
    rustPlatform.buildRustPackage (
      rec {
        inherit
          pname
          version
          src
          cargoHash
          ;

        nativeBuildInputs = [ protobuf ];

        cargoBuildFlags = [
          "--package"
          pname
        ];

        cargoTestFlags = cargoBuildFlags;

        meta = {
          description = "Fast, collaborative live terminal sharing over the web";
          homepage = "https://github.com/ekzhang/sshx";
          changelog = "https://github.com/ekzhang/sshx/releases/tag/v${version}";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [
            pinpox
            kranzes
          ];
          mainProgram = pname;
        };
      }
      // args
    );
in
{
  sshx = mkSshxPackage {
    pname = "sshx";
    cargoHash = "sha256-QftBUGDQvCSHoOBLnEzNOe1dMTpVTvMDXNp5qZr0C2M=";
  };

  sshx-server = mkSshxPackage rec {
    pname = "sshx-server";
    cargoHash = "sha256-QftBUGDQvCSHoOBLnEzNOe1dMTpVTvMDXNp5qZr0C2M=";

    postPatch = ''
      substituteInPlace crates/sshx-server/src/web.rs \
        --replace-fail 'ServeDir::new("build")' 'ServeDir::new("${passthru.web.outPath}")' \
        --replace-fail 'ServeFile::new("build/spa.html")' 'ServeFile::new("${passthru.web.outPath}/spa.html")'
    '';

    passthru.web = buildNpmPackage {
      pname = "sshx-web";

      inherit
        version
        src
        ;

      postPatch = ''
        substituteInPlace vite.config.ts \
          --replace-fail 'execSync("git rev-parse --short HEAD").toString().trim()' '"${src.rev}"'
      '';

      npmDepsHash = "sha256-QdgNtQMjK229QzB5LbCry1hKVPon8IWUnj+v5L7ydfI=";

      installPhase = ''
        cp -r build $out
      '';
    };
  };
}
