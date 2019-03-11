{ stdenv
, fetchFromGitHub
, makeWrapper
, gdb
, future
, isort
, psutil
, pycparser
, pyelftools
, python-ptrace
, ROPGadget
, six
, unicorn
, pygments
, }:

stdenv.mkDerivation rec {
  name = "pwndbg-${version}";
  version = "2018.07.29";

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = version;
    sha256 = "1illk1smknaaa0ck8mwvig15c8al5w7fdp42a748xvm8wvxqxdsc";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [
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
