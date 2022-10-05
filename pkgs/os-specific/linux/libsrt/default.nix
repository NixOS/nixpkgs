{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libsrt";
  version = "20210918";

  src = fetchFromGitHub {
    owner = "faragon";
    repo = "libsrt";
    rev = "eee28e6dfc23f76c7b8f76f32ef68418619064be";
    sha256 = "sha256-zv47HSqULGUrVAgF05Myn5MO0G8Zt+uummHlxr2AIy4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "libsrt: Safe Real-Time library for the C programming language";
    homepage = "https://github.com/faragon/libsrt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sebtm ];
    platforms = platforms.linux;
  };
}
