{
  stdenv,
  fetchFromGitHub,
  cmake,
  apple_sdk_sierra,
  xnu-new,
}:

stdenv.mkDerivation rec {
  name = "swift-corelibs-libdispatch";
  src = fetchFromGitHub {
    owner = "apple";
    repo = name;
    rev = "f83b5a498bad8e9ff8916183cf6e8ccf677c346b";
    sha256 = "1czkyyc9llq2mnqfp19mzcfsxzas0y8zrk0gr5hg60acna6jkz2l";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    apple_sdk_sierra.sdk
    xnu-new
  ];
}
