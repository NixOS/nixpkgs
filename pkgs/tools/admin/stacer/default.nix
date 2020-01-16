{ lib, mkDerivation, fetchFromGitHub
, cmake
, qtcharts
, qttools
}:

mkDerivation rec {
  pname = "stacer";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "oguzhaninan";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qndzzkbq6abapvwq202kva8j619jdn9977sbqmmfs9zkjz4mbsd";
  };

  nativeBuildInputs = [ cmake qttools ];

  buildInputs = [ qtcharts ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux System Optimizer and Monitoring";
    homepage = "https://github.com/oguzhaninan/Stacer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jonringer ];
  };
}

