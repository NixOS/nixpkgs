{ cmake, fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "pcm";
  version = "202307";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    hash = "sha256-GeLiJT5AwsMWw0ErdwD6C1jtUZjUxGw5GRSvenu3W18=";
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
