{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "23.11";
  pname = "intel-cmt-cat";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-cmt-cat";
    rev = "v${version}";
    sha256 = "sha256-/OSU/7QR8NAjcAIo+unVQfORvCH5VpjfRn5sIrCxwbE=";
  };

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" "NOLDCONFIG=y" ];

  meta = with lib; {
    description = "User space software for Intel(R) Resource Director Technology";
    homepage = "https://github.com/intel/intel-cmt-cat";
    license = licenses.bsd3;
    maintainers = with maintainers; [ arkivm ];
    platforms = [ "x86_64-linux" ];
  };
}
