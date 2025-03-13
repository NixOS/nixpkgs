{ 
    stdenv,
    cmake,
    lib,
    ninja,
    gcc,
    git,
    python311,
    fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "Pyroveil";
  # I don't see a version specification anywhere, only in json files.
  version = "2.0.0";
  src = (fetchFromGitHub {
    owner = "HansKristian-Work";
    repo = "pyroveil";
    rev = "7fde4d6d0ebc664f33ebc6a42d8c2975bf353bfe";
    sha256 = "sha256-sKvqcmQsbK8YuCdN2+5NKmyE0Sc8iA45IpYnFRItqiU=";
    fetchSubmodules = true;
  }).overrideAttrs (oldAttrs: {
    env = oldAttrs.env or { } // {
      GIT_CONFIG_COUNT = 1;
      GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
      GIT_CONFIG_VALUE_0 = "git@github.com:";
    };
  });

  nativeBuildInputs = [ 
    cmake 
    ninja 
    gcc 
    git 
    python311  
  ];
  
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  postPatch = ''
    substituteInPlace layer/CMakeLists.txt \
    --replace "\''${CMAKE_INSTALL_PREFIX}/\''${CMAKE_INSTALL_LIBDIR}" "\''${CMAKE_INSTALL_FULL_LIBDIR}"
  '';

  meta = {
    description =
      "Vulkan layer to replace shaders or roundtrip them to workaround driver bugs";
    license = lib.licenses.mit;
  };
}
