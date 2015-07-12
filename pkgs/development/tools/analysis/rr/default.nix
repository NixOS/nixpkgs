{ stdenv, fetchFromGitHub, cmake, libpfm, zlib, python }:

stdenv.mkDerivation rec {
  version = "3.2.0";
  name = "rr-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rr";
    rev = version;
    sha256 = "14vvrsvjgbcgsckij680103kkgcvw6wx1n9bisls7mcyiqx1iikw";
  };

  patchPhase = ''
    substituteInPlace src/Command.cc --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
  ''
  # On 64bit machines, don't build the 32-bit components for debugging
  # 32-bit binaries. This sucks but I don't know how to make 'gcc' cooperate
  # easily with how CMake works to build 32 and 64bit binaries at once.
  + stdenv.lib.optionalString (stdenv.system == "x86_64-linux") ''
    substituteInPlace CMakeLists.txt --replace 'if(rr_64BIT)' 'if(false)'
  '';

  buildInputs = [ cmake libpfm zlib python ];
  cmakeFlags = "-DCMAKE_C_FLAGS_RELEASE:STRING= -DCMAKE_CXX_FLAGS_RELEASE:STRING=";

  meta = {
    homepage = http://rr-project.org/;
    description = "Records nondeterministic executions and debugs them deterministically";
    longDescription = ''
      rr aspires to be your primary debugging tool, replacing -- well,
      enhancing -- gdb. You record a failure once, then debug the
      recording, deterministically, as many times as you want. Every
      time the same execution is replayed.
    '';

    license = "custom";
    maintainers = with stdenv.lib.maintainers; [ pierron thoughtpolice ];
    platforms = stdenv.lib.platforms.linux;
  };
}
