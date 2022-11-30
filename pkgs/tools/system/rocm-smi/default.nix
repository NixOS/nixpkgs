{ lib, stdenv, fetchFromGitHub, writeScript, cmake, wrapPython }:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-smi";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm_smi_lib";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-UbGbkH2vhQ9gv3sSoG+mXap+MdcrP61TN5DcP5F/5nQ=";
  };

  nativeBuildInputs = [ cmake wrapPython ];

  patches = [ ./cmake.patch ];

  postInstall = ''
    wrapPythonProgramsIn $out
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} -sL "https://api.github.com/repos/RadeonOpenCompute/rocm_smi_lib/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocm-smi "$version" --ignore-same-hash
  '';

  meta = with lib; {
    description = "System management interface for AMD GPUs supported by ROCm";
    homepage = "https://github.com/RadeonOpenCompute/rocm_smi_lib";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = [ "x86_64-linux" ];
  };
})
