{ stdenv, buildGoPackage, fetchgit, qemu, docker, which, makeWrapper }:

buildGoPackage rec {
  pname = "out-of-tree";
  version = "1.0.1";

  buildInputs = [ makeWrapper ];

  goPackagePath = "code.dumpstack.io/tools/${pname}";

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "https://code.dumpstack.io/tools/${pname}.git";
    sha256 = "0p0ps73w6lmsdyf7irqgbhfxjg5smgbn081d06pnr1zmxvw8dryx";
  };

  goDeps = ./deps.nix;

  postFixup = ''
    wrapProgram $bin/bin/out-of-tree \
      --prefix PATH : "${stdenv.lib.makeBinPath [ qemu docker which ]}"
  '';

  meta = with stdenv.lib; {
    description = "kernel {module, exploit} development tool";
    homepage = https://out-of-tree.io;
    maintainers = [ maintainers.dump_stack ];
    license = licenses.agpl3Plus;
  };
}
