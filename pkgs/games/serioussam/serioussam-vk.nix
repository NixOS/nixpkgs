{ callPackage
, fetchFromGitHub
, vulkan-headers
, vulkan-loader
}:

callPackage ./generic.nix rec {
  pname = "serioussam-vk";

  version = "1.10.6b";

  src = fetchFromGitHub {
    owner = "tx00100xt";
    repo = "SeriousSamClassic-VK";
    rev = version;
    hash = "sha256-nPmxGnMjaYPTnQYxbGEMGaW/6eRr1Smr5SmFRWsrdQs=";
  };

  extraNativeBuildInputs = [ vulkan-headers ];
  extraBuildInputs = [ vulkan-loader ];
}
