{
  lib, stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  python3,
  boost
}:

stdenv.mkDerivation rec {
  pname = "cli11";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${version}";
    sha256 = "0hbch0vk8irgmiaxnfqlqys65v1770rxxdfn3d23m2vqyjh0j9l6";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ boost python3 ];

  doCheck = true;

  preConfigure = ''
    rm -rfv extern/googletest
    ln -sfv ${gtest.src} extern/googletest
    sed -i '/TrueFalseTest/d' tests/CMakeLists.txt
  '';

  meta = with lib; {
    description = "Command line parser for C++11";
    homepage = "https://github.com/CLIUtils/CLI11";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };

}
