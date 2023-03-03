{ clangStdenv
, cmake
, fetchFromGitHub
, lib
, zlib
}:
let
  pname = "HdrHistogram_c";
  version = "0.11.5";
in
clangStdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "HdrHistogram";
    repo = "HdrHistogram_c";
    rev = version;
    sha256 = "sha256-29if+0H8wdpQBN48lt0ylGgtUCv/tJYZnG5LzcIqXDs=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];
  meta = with lib; {
    description = "C port of the HdrHistogram";
    license = licenses.bsd2;
    homepage = "https://github.com/HdrHistogram/HdrHistogram_c";
    maintainers = with maintainers; [ avakhrenev ];
    platforms = platforms.unix;
  };
}
