{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "4.4.1";
  pname = "intel-cmt-cat";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-cmt-cat";
    rev = "v${version}";
    sha256 = "sha256-6v9MRIW9Wqojia6GZNM75AvoYJGJ9C/k+ShwQKOjiL8=";
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
