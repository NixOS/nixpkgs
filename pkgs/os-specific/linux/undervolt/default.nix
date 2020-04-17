{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.2.11";
  pname = "undervolt";

  src = fetchFromGitHub {
    owner = "georgewhewell";
    repo = "undervolt";
    rev = version;
    sha256 = "18mnf3x687qal7k8yk2sdxzgbyn3rqchgflbi1sksryznmksqqw5";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/georgewhewell/undervolt/";
    description = "A program for undervolting Intel CPUs on Linux";

    longDescription = ''
      Undervolt is a program for undervolting Intel CPUs under Linux. It works in a similar
      manner to the Windows program ThrottleStop (i.e, MSR 0x150). You can apply a fixed
      voltage offset to one of 5 voltage planes, and override your systems temperature
      target (CPU will throttle when this temperature is reached).
    '';
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
