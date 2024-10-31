{ lib
, stdenv
, fetchFromBitbucket
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wolfstoneextract";
  version = "1.2";

  src = fetchFromBitbucket {
    owner = "ecwolf";
    repo = "wolfstoneextract";
    rev = finalAttrs.version;
    hash = "sha256-yrYLP2ewOtiry+EgH1IEaxz2Q55mqQ6mRGSxzVUnJ8Q=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Utility to extract Wolfstone data from Wolfenstein II";
    mainProgram = "wolfstoneextract";
    homepage = "https://bitbucket.org/ecwolf/wolfstoneextract/src/master/";
    platforms = [ "x86_64-linux" ];
    license = with licenses; [ gpl3Only bsd3 ];
    maintainers = with maintainers; [ keenanweaver ];
  };
})
