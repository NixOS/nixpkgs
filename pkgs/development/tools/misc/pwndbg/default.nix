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
  version = "2019.12.09";
  format = "other";

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = version;
    sha256 = "0kn28mjdq91zf7d6vqzbm74f0ligp829m9jzjxfn4zlx6wrmkd0s";
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
    homepage = "https://github.com/pwndbg/pwndbg";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
  };
}
