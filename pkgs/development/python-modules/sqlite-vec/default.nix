{
  lib,
  stdenv,
  fetchPypi,
  buildPythonPackage,
}:
let
  platforms = {
    aarch64-darwin = "macosx_11_0_arm64";
    aarch64-linux = "manylinux_2_17_aarch64.manylinux2014_aarch64";
    x86_64-darwin = "macosx_10_6_x86_64";
    x86_64-linux = "manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux1_x86_64";
  };
  platform =
    platforms.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform}");
  hashes = {
    aarch64-darwin = "sha256-/co19+4yQ2aKBVJV1N7k3qfu1aBtqMrUCfifrPRZU2E=";
    aarch64-linux = "sha256-ewUZ2c2WFkzS4I6O7SJRl/nNLwvoLLBFZ2kqCkvgLaM=";
    x86_64-darwin = "sha256-d0kbyqbUlvKstcwND/C4lkQ08UFSPBIeMT+afYCI3uM=";
    x86_64-linux = "sha256-gjsEk63YDX/oKrD+Jd98BwP0dSlBruHHsrAs7JZWyyQ=";
  };
  hash = hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform}");
in
# Github repo exists, but lacks the files needed to build from source.
buildPythonPackage rec {
  pname = "sqlite-vec";
  version = "0.1.6";
  format = "wheel";

  src = fetchPypi {
    inherit version;
    pname = "sqlite_vec";
    dist = "py3";
    python = "py3";
    inherit format platform hash;
  };

  doCheck = false; # No tests provided

  pythonImportsCheck = [ "sqlite_vec" ];

  meta = {
    description = "Vector search SQLite extension";
    homepage = "https://github.com/asg017/sqlite-vec";
    changelog = "https://github.com/asg017/sqlite-vec/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sarahec ];
    platforms = builtins.attrNames platforms;
  };
}
