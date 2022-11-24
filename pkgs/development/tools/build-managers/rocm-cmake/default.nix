{ lib, stdenv, fetchFromGitHub, writeScript, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-cmake";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm-cmake";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-AOn3SLprHdeo2FwojQdhRAttUHuaWkO6WlymK8Q8lbc=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/RadeonOpenCompute/rocm-cmake/tags" | jq '.[].name | split("-") | .[1] | select( . != null )' --raw-output | sort -n | tail -1)"
    update-source-version rocm-cmake "$version" --ignore-same-hash
  '';

  meta = with lib; {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/RadeonOpenCompute/rocm-cmake";
    license = licenses.mit;
    maintainers = teams.rocm.members;
    platforms = platforms.unix;
  };
})
