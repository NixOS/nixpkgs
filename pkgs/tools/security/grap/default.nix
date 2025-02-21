{ lib, stdenv, fetchFromGitHub, boost, libseccomp, flex, swig, bison, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "grap";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "QuoSecGmbH";
    repo = "grap";
    rev = "v${version}";
    sha256 = "1fkdi7adfffxg1k4h6r9i69i3wi93s44c1j4cvr69blxsfh0mcnc";
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    python3
    swig
  ];

  buildInputs = [
    boost.all
    libseccomp
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DPYTHON_SITE_DIR=$out/${python3.sitePackages}"
    "../src"
  ];

  postPatch = ''
    substituteInPlace src/tools/grap-match/CMakeLists.txt --replace "/usr/local/bin" "$out/bin"
    substituteInPlace src/tools/grap/CMakeLists.txt --replace "/usr/local/bin" "$out/bin"
  '';

  meta = with lib; {
    description = "Define and match graph patterns within binaries";
    longDescription = ''
      grap takes patterns and binary files, uses a Casptone-based disassembler to obtain the control flow graphs from the binaries, then matches the patterns against them.

      Patterns are user-defined graphs with instruction conditions ("opcode is xor and arg1 is eax") and repetition conditions (3 identical instructions, basic blocks...).
    '';
    homepage = "https://github.com/QuoSecGmbH/grap/";
    license = licenses.mit;
    maintainers = [ maintainers.s1341 ];
    platforms = platforms.linux;
  };
}
