{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "stderred";
  version = "unstable-2017-07-20";

  src = fetchFromGitHub {
    owner = "sickill";
    repo = "stderred";
    rev = "399e3b199c6de0ac6fdda3c30fb845ff36a75b1f";
    sha256 = "08wdmn49q115gppvgff9v14hhj2vddlrb6whl9sl7fsa43f5lmnx";
  };

  nativeBuildInputs = [
    cmake
  ];

  sourceRoot = "${src.name}/src";

  meta = with stdenv.lib; {
    description = "stderr in red";
    homepage = "https://github.com/sickill/stderred";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
