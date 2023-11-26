{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, cmakeMinimal
, protobuf
, fetchurl
, stdenv
}:
buildPythonPackage rec {
  pname = "vl-convert-python";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vl-convert";
    rev = "v${version}";
    hash = "sha256-OgaNMRfTVvWOSZmFk0KrpLepxf/uYS2Qu5fGULdHbBA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-WZkaikxAQEOWpNhhDkBbFuEcz7HymgqJrGBRr5xAuGY=";
  };

  buildAndTestSubdir = "vl-convert-python";

  RUSTY_V8_ARCHIVE =
      let
        fetch_librusty_v8 = args:
          fetchurl {
            name = "librusty_v8-${args.version}";
            url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a";
            sha256 = args.shas.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
            meta = { inherit (args) version; };
          };
      in
      fetch_librusty_v8 {
        version = "0.81.0";
        shas = {
          x86_64-linux = "1hdxp0f0nhc11w98qkys61vbjvg857hld8l7cg2cxfpcdxicpgkv";
          aarch64-linux = "16zry3qvzn1rwvwczc4f9qm90ca2fwag7pvjwqr6nrznwird9xy0";
          x86_64-darwin = "02pa8f9qygcldaahlp6pw59ql2sqbqrnf4xjvvmbxv8c5j5x3fai";
          aarch64-darwin = "0z8g12pm2vakq6n6bs49khdg8y79mgsn3wvp4asmbrkgc1a7frz3";
        };
      };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    cmakeMinimal
    protobuf
  ];
  dontUseCmakeConfigure = true;

  meta = {
    description = "Utilities for converting Vega-Lite specs from the command line and Python";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/vega/vl-convert";
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
