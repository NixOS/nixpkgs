{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, lsb-release
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipcc";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "HIPCC";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-lJX6nF1V4YmK5ai7jivXlRnG3doIOf6X9CWLHVdRuVg=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace src/hipBin_amd.h \
      --replace "/usr/bin/lsb_release" "${lsb-release}/bin/lsb_release"
  '';

  postInstall = ''
    rm -r $out/hip/bin
    ln -s $out/bin $out/hip/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Compiler driver utility that calls clang or nvcc";
    homepage = "https://github.com/ROCm/HIPCC";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "6.0.0";
  };
})
