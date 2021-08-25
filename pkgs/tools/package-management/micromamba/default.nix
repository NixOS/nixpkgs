{ lib, stdenv, fetchFromGitHub, cmake
, cli11, nlohmann_json, curl, libarchive, libyamlcpp, libsolv, reproc
}:

let
  libsolv' = libsolv.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DENABLE_CONDA=true"  # Maybe enable this in the original libsolv package? No idea about the implications.
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "micromamba";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    rev = version;
    sha256 = "0a5kmwk44ll4d8b2akjc0vm6ap9jfxclcw4fclvjxr2in3am9256";
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
