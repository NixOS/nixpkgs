{ buildPackages, cmake, fetchFromGitHub, lib, ninja, stdenv, testers, quick-lint-js }:

let
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    sha256 = "sha256-5+Cyw1cLgBkTePNNFoNAF2oHnLQDHr4vHiaZHJrewug=";
  };

  quick-lint-js-build-tools = buildPackages.stdenv.mkDerivation {
    pname = "quick-lint-js-build-tools";
    inherit version src;

    patches = [ ./build-tools-install.patch ];

    nativeBuildInputs = [ cmake ninja ];
    doCheck = false;

    cmakeFlags = [
      "-DQUICK_LINT_JS_ENABLE_BUILD_TOOLS=ON"
      # Temporary workaround for https://github.com/NixOS/nixpkgs/pull/108496#issuecomment-1192083379
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
    ];
    ninjaFlags = "quick-lint-js-build-tools";

    installPhase = ''
      runHook preInstall
      cmake --install . --component build-tools
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "quick-lint-js";
  inherit version src;

  nativeBuildInputs = [ cmake ninja ];
  doCheck = true;

  cmakeFlags = [
    "-DQUICK_LINT_JS_USE_BUILD_TOOLS=${quick-lint-js-build-tools}/bin"
    # Temporary workaround for https://github.com/NixOS/nixpkgs/pull/108496#issuecomment-1192083379
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  passthru.tests = {
    version = testers.testVersion { package = quick-lint-js; };
  };

  meta = with lib; {
    description = "Find bugs in Javascript programs";
    homepage = "https://quick-lint-js.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ratsclub ];
    platforms = platforms.all;
  };

  # Expose quick-lint-js-build-tools to nix repl as quick-lint-js.build-tools.
  passthru.build-tools = quick-lint-js-build-tools;
}
