{ lib
, stdenv
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
    ropgadget
    six
    unicorn
    pygments
  ];

in stdenv.mkDerivation rec {
  pname = "pwndbg";
  version = "2022.01.05";
  format = "other";

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = version;
    sha256 = "sha256-24WWA3wLUxylC8LkukwTOcqbpxpAg8DfrEkI3Ikyzlk=";
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

  meta = with lib; {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    homepage = "https://github.com/pwndbg/pwndbg";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mic92 ];
  };
}
