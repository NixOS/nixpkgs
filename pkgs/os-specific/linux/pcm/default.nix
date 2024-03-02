{ cmake, fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "pcm";
  version = "202401";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    hash = "sha256-S4E9q4pdF9pT0ehKkeOMbJEFlTV9zB15BZA0R+cjVi8=";
  };

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Processor counter monitor";
    homepage = "https://www.intel.com/software/pcm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ roosemberth ];
    platforms = [ "x86_64-linux" ];
  };
}
