{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cli11
, cmake
, curl
, ghc_filesystem
, libarchive
, libsolv
, libyamlcpp
, nlohmann_json
, python3
, reproc
, spdlog
, termcolor
, tl-expected
}:

let
  libsolv' = libsolv.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DENABLE_CONDA=true"
    ];

    patches = [
      # Apply the same patch as in the "official" boa-forge build:
      # https://github.com/mamba-org/boa-forge/tree/master/libsolv
      (fetchpatch {
        url = "https://raw.githubusercontent.com/mamba-org/boa-forge/20530f80e2e15012078d058803b6e2c75ed54224/libsolv/conda_variant_priorization.patch";
        sha256 = "1iic0yx7h8s662hi2jqx68w5kpyrab4fr017vxd4wyxb6wyk35dd";
      })
    ];
  });

  spdlog' = spdlog.overrideAttrs (oldAttrs: {
    # Required for header files. See alse:
    # https://github.com/gabime/spdlog/pull/1241 (current solution)
    # https://github.com/gabime/spdlog/issues/1897 (previous solution)
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DSPDLOG_FMT_EXTERNAL=OFF"
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "micromamba";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    rev = "micromamba-" + version;
    sha256 = "sha256-CszDmt3SElHo1D2sNy2tPhZ43YD3pDjT8+fp2PVk+7Y=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cli11
    nlohmann_json
    curl
    libarchive
    libyamlcpp
    libsolv'
    reproc
    spdlog'
    termcolor
    ghc_filesystem
    python3
    tl-expected
  ];

  cmakeFlags = [
    "-DBUILD_LIBMAMBA=ON"
    "-DBUILD_SHARED=ON"
    "-DBUILD_MICROMAMBA=ON"
    # "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
  ];

  meta = with lib; {
    description = "Reimplementation of the conda package manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ mausch ];
  };
}
