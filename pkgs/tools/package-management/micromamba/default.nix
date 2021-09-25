{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake
, cli11, nlohmann_json, curl, libarchive, libyamlcpp, libsolv, reproc
}:

let
  libsolv' = libsolv.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DENABLE_CONDA=true"
    ];

    patches = [
      # Patch added by the mamba team
      (fetchpatch {
        url = "https://raw.githubusercontent.com/mamba-org/boa-forge/f766da0cc18701c4d107a41de22417a65b53cc2d/libsolv/add_strict_repo_prio_rule.patch";
        sha256 = "19c47i5cpyy88nxskf7k6q6r43i55w61jvnz7fc2r84hpjkcrv7r";
      })
      # Patch added by the mamba team
      (fetchpatch {
        url = "https://raw.githubusercontent.com/mamba-org/boa-forge/f766da0cc18701c4d107a41de22417a65b53cc2d/libsolv/conda_variant_priorization.patch";
        sha256 = "1iic0yx7h8s662hi2jqx68w5kpyrab4fr017vxd4wyxb6wyk35dd";
      })
      # Patch added by the mamba team
      (fetchpatch {
        url = "https://raw.githubusercontent.com/mamba-org/boa-forge/f766da0cc18701c4d107a41de22417a65b53cc2d/libsolv/memcpy_to_memmove.patch";
        sha256 = "1c9ir40l6crcxllj5zwhzbrbgibwqaizyykd0vip61gywlfzss64";
      })
    ];
  });

  # fails linking with yaml-cpp 0.7.x
  libyamlcpp' = libyamlcpp.overrideAttrs (oldAttrs: rec {

    version = "0.6.3";

    src = fetchFromGitHub {
      owner = "jbeder";
      repo = "yaml-cpp";
      rev = "yaml-cpp-${version}";
      sha256 = "0ykkxzxcwwiv8l8r697gyqh1nl582krpvi7m7l6b40ijnk4pw30s";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "micromamba";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    rev = version;
    sha256 = "1zksp4zqj4wn9p9jb1qx1acajaz20k9xnm80yi7bab2d37y18hcw";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cli11
    nlohmann_json
    curl
    libarchive
    libyamlcpp'
    libsolv'
    reproc
    # python3Packages.pybind11 # Would be necessary if someone wants to build with bindings I guess.
  ];

  cmakeFlags = [
    "-DBUILD_BINDINGS=OFF" # Fails to build, I don't think it's necessary for now.
    "-DBUILD_EXE=ON"
  ];

  CXXFLAGS = "-DMAMBA_USE_STD_FS";

  meta = with lib; {
    description = "Reimplementation of the conda package manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mausch ];
  };
}
