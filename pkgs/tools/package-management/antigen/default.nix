{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "antigen-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = https://github.com/zsh-users/antigen/archive/v1.tar.gz;
    sha256 = "0ivq9lzqqbkcyscbh3hhp44iwvmhfcqbkzn87ai3cgmwsysxfjvd";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $prefix/bin/
    cp antigen.zsh $prefix/bin/
  '';

  meta = {
    description = "Package manager for the zsh shell.";
    maintainers = [ stdenv.lib.maintainers.aaronschif ];
    longDescription = ''
      Antigen is a small set of functions that help you easily manage your shell (zsh) plugins,
      called bundles. The concept is pretty much the same as bundles in a typical vim+pathogen
      setup. Antigen is to zsh, what Vundle is to vim.
    '';
    homepage = https://github.com/zsh-users/antigen;
  };
}
