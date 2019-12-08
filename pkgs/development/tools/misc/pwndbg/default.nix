{ stdenv
, python3
, fetchFromGitHub
, makeWrapper
, gdb
}:

let
  pythonPath = with python3.pkgs; makePythonPath [
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

in stdenv.mkDerivation rec {
  pname = "pwndbg";
  version = "2019.01.25";
  format = "other";

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = version;
    sha256 = "0k7n6pcrj62ccag801yzf04a9mj9znghpkbnqwrzz0qn3rs42vgs";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/pwndbg
    cp -r *.py pwndbg $out/share/pwndbg
    chmod +x $out/share/pwndbg/gdbinit.py
    makeWrapper ${gdb}/bin/gdb $out/bin/pwndbg \
      --add-flags "-q -x $out/share/pwndbg/gdbinit.py" \
      --set NIX_PYTHONPATH ${pythonPath}
  '';

  meta = with stdenv.lib; {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    homepage = http://pwndbg.com;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
  };
}
