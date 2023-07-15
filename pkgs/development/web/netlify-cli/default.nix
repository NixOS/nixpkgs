{ lib, buildNpmPackage, callPackage, esbuild_netlify, fetchFromGitHub, python3 }:

let
  pname = "netlify-cli";
  version = "15.9.0";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-cfQGzsZipp0HDPqVuW8QjGo23CckmOhD79r34GaY8eY=";
  };

  site = buildNpmPackage {
    pname = "${pname}-site";
    inherit version src;
    npmDepsHash = "sha256-H1FwmdL8Ba3QcAMg+AjERJwdzfFXMPTqC9zc394ujEw=";
    postPatch = ''
      cd site
    '';
    env.NODE_OPTIONS = "--openssl-legacy-provider";
    npmBuildScript = "build:site";
    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';
  };
in buildNpmPackage rec {
  inherit pname version src;

  postPatch = ''
    substituteInPlace package.json --replace 'is-ci ||' 'true ||'
    rm -rf site
    ln -s ${site} site
  '';

  npmDepsHash = "sha256-cs37SFom2fR9yuGNmyZ5QATiE2P/WiBNyqF+54VdGDQ=";

  nativeBuildInputs = [
    python3
  ];

  npmInstallFlagsArray = [
    "--omit=dev"
  ];

  env.ESBUILD_BINARY_PATH = "${esbuild_netlify}/bin/esbuild";

  dontNpmBuild = true;

  passthru.tests.test = callPackage ./test.nix { };

  meta = with lib; {
    description = "Netlify Command Line Interface";
    homepage = "https://github.com/netlify/cli";
    changelog = "https://github.com/netlify/cli/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
