{ stdenv, fetchFromGitHub, pythonPackages, makeWrapper, gdb }:

stdenv.mkDerivation rec {
  name = "pwndbg-2018-04-06";

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = "e225ba9f647ab8f7f4871075529c0ec239f43300";
    sha256 = "1s6m93qi3baclgqqii4fnmzjmg0c6ipkscg7xiljaj5z4bs371j4";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with pythonPackages; [
    future
    isort
    psutil
    pycparser
    pyelftools
    python-ptrace
    ROPGadget
    six
    unicorn
    pygments
    enum34
  ];

  installPhase = ''
    mkdir -p $out/share/pwndbg
    cp -r *.py pwndbg $out/share/pwndbg
    makeWrapper ${gdb}/bin/gdb $out/bin/pwndbg \
      --add-flags "-q -x $out/share/pwndbg/gdbinit.py"
  '';

  preFixup = ''
    sed -i "/import sys/a import sys; sys.path[0:0] = '$PYTHONPATH'.split(':')" \
      $out/share/pwndbg/gdbinit.py
  '';

  meta = with stdenv.lib; {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    homepage = http://pwndbg.com;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
  };
}
