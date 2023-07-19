{ lib
, stdenv
, python3
, fetchFromGitHub
, makeWrapper
, gdb
}:

let
  venv = python3.withPackages (p: with p; [
    capstone
    psutil
    pwntools
    pycparser
    pyelftools
    pygments
    unicorn
    rpyc
    tabulate
    requests
    types-requests
    typing-extensions
  ]);
  binPath = lib.makeBinPath ([
    python3.pkgs.pwntools   # ref: https://github.com/pwndbg/pwndbg/blob/2022.12.19/pwndbg/wrappers/checksec.py#L8
  ] ++ lib.optionals stdenv.isLinux [
    python3.pkgs.ropper     # ref: https://github.com/pwndbg/pwndbg/blob/2022.12.19/pwndbg/commands/ropper.py#L30
    python3.pkgs.ropgadget  # ref: https://github.com/pwndbg/pwndbg/blob/2022.12.19/pwndbg/commands/rop.py#L32
  ]);

in stdenv.mkDerivation rec {
  pname = "pwndbg";
  version = "2023.07.17";
  format = "other";

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = version;
    sha256 = "sha256-HElzkHv94tEVq1mUeNo75Ja7yMaup2CIh96nWivkkjg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/pwndbg
    cp -r *.py pwndbg gdb-pt-dump $out/share/pwndbg
    chmod +x $out/share/pwndbg/gdbinit.py
    ln -s ${venv} $out/share/pwndbg/.venv

    # TODO: remove after capstone>=5 in nixpkgs
    sed -i 's@CS_ARCH_RISCV@99999@g' $out/share/pwndbg/pwndbg/disasm/__init__.py

    makeWrapper ${gdb}/bin/gdb $out/bin/pwndbg \
      --add-flags "-q -x $out/share/pwndbg/gdbinit.py" \
      --prefix PATH : ${binPath} \
      --set-default LC_CTYPE "C.UTF-8"
  '';

  meta = with lib; {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    homepage = "https://github.com/pwndbg/pwndbg";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mic92 patryk4815 ];
    # not supported on aarch64-darwin see: https://inbox.sourceware.org/gdb/3185c3b8-8a91-4beb-a5d5-9db6afb93713@Spark/
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
