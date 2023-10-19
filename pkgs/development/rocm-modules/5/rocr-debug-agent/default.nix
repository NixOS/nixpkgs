{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, clr
, git
, rocdbgapi
, elfutils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocr-debug-agent";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "rocr_debug_agent";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-AUDbNrFtUQ5Hm+uv5KMovh7P9wXQKLyRNx9gEQFnv6Y=";
  };

  nativeBuildInputs = [
    cmake
    clr
    git
  ];

  buildInputs = [
    rocdbgapi
    elfutils
  ];

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${clr}/lib/cmake/hip"
    "-DHIP_ROOT_DIR=${clr}"
    "-DHIP_PATH=${clr}"
  ];

  # Weird install target
  postInstall = ''
    rm -rf $out/src
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Library that provides some debugging functionality for ROCr";
    homepage = "https://github.com/ROCm-Developer-Tools/rocr_debug_agent";
    license = with licenses; [ ncsa ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
