{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, boost, libevdevplus, libuinputplus, iodash, cxxopts}:

stdenv.mkDerivation rec {
  pname = "ydotool";
  version = "unstable-2021-01-20";

  src = fetchFromGitHub {
    owner = "ReimuNotMoe";
    repo = "ydotool";
    rev = "b1d041f52f7bac364d6539b1251d29c3b77c0f37";
    sha256 = "1gzdbx6fv0dbcyia3yyzhv93az2gf90aszb9kcj5cnxywfpv9w9g";
  };

  # upstream decided to use a cpp package manager called cpm.
  # we need to disable that because it wants networking, furthermore,
  # it does some system folder creating which also needs to be disabled.
  # Both changes are to respect the sandbox.
  patches = [ ./fixup-cmakelists.patch ];


  # cxxopts is a header only library.
  # See pull request: https://github.com/ReimuNotMoe/ydotool/pull/105
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace \
      "PUBLIC cxxopts" \
      "PUBLIC"
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    boost libevdevplus libuinputplus iodash cxxopts
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Generic Linux command-line automation tool";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = with platforms; linux;
  };
}
