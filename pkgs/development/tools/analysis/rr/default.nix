{ stdenv, fetchFromGitHub, cmake, libpfm, zlib, python, pkgconfig, pythonPackages, which, procps }:

stdenv.mkDerivation rec {
  version = "4.0.3";
  name = "rr-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rr";
    rev = version;
    sha256 = "0k12r1hzkn5286kz5cg4mvii92m0prs58przchr495r9hfjcy276";
  };

  patchPhase = ''
    substituteInPlace src/Command.cc --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    patchShebangs .
  '';

  buildInputs = [ cmake libpfm zlib python pkgconfig pythonPackages.pexpect which procps ];
  cmakeFlags = "-DCMAKE_C_FLAGS_RELEASE:STRING= -DCMAKE_CXX_FLAGS_RELEASE:STRING=";

  enableParallelBuilding = true;

  # FIXME
  #doCheck = true;

  preCheck = "export HOME=$TMPDIR";

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
