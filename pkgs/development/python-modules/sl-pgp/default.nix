{
  lib,
  buildPythonPackage,
  fetchurl,
  stdenv,
}:

let
  wheels = {
    x86_64-linux = {
      platform = "manylinux_2_31_x86_64";
      hash = "sha256-HNpdGVM4jSVkHgOD9twGMKQvIiVqodqe+7mXmQm3HRc=";
    };
    aarch64-linux = {
      platform = "manylinux_2_31_aarch64";
      hash = "sha256-q66fWNovtygbE8NJvGDP01mIUCIMmrcEeOTrZCOGOtw=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-Fv5x4lzqgFerzF9BEaaNMd6aIR1Icg7HrWfdQe7chiQ=";
    };
  };

  wheel = wheels.${stdenv.hostPlatform.system};

in
buildPythonPackage (finalAttrs: {
  pname = "sl-pgp";
  version = "0.1.1";
  format = "wheel";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/simple-login/sl-pgp-rs/releases/download/${finalAttrs.version}/sl_pgp-${finalAttrs.version}-cp310-abi3-${wheel.platform}.whl";
    inherit (wheel) hash;
  };

  pythonImportsCheck = [ "sl_pgp" ];

  meta = {
    description = "Rust-backed PGP operations for SimpleLogin";
    homepage = "https://github.com/simple-login/sl-pgp-rs";
    changelog = "https://github.com/simple-login/sl-pgp-rs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = builtins.attrNames wheels;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
