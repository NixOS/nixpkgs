{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
    name = "pyenv-virtualenv-${version}";
    version = "20140609";

    src = fetchurl {
        url = "https://github.com/yyuu/pyenv-virtualenvwrapper/archive/v${version}.tar.gz";
        sha256 = "1gq3xl5k37pvyxvc1ba5s0abhkswfjx589lm523cb523jp215j61";
    };

    phases = "unpackPhase installPhase";

    installPhase = ''
      copy() {
          mkdir -p $out/share/plugins/pyenv-virtualenvwrapper
          cp -r $@ $out/share/plugins/pyenv-virtualenvwrapper
      }

      copy bin
    '';
}
