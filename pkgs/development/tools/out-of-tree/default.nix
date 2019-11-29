{ stdenv, buildGoPackage, fetchgit, qemu, docker, which, makeWrapper }:

buildGoPackage rec {
  pname = "out-of-tree";
  version = "1.1.1";

  buildInputs = [ makeWrapper ];

  goPackagePath = "code.dumpstack.io/tools/${pname}";

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "https://code.dumpstack.io/tools/${pname}.git";
    sha256 = "048jda3vng11mg62fd3d8vs9yjsp569zlfylnkqv8sb6wd1qn66d";
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
