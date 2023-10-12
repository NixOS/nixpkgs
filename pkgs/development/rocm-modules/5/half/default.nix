{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "half";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "half";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-82It+/wm8+umBdQYn7lz/fS69h+f0mzwPdGxoJNYUq0=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "C++ library for half precision floating point arithmetics";
    homepage = "https://github.com/ROCmSoftwarePlatform/half";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.unix;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
