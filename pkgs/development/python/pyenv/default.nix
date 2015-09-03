{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
    name = "pyenv-${version}";
    version = "20150901";

    src = fetchurl {
        url = "https://github.com/yyuu/pyenv/archive/v${version}.tar.gz";
        sha256 = "1vmhk4sc8sgwbfwzypj4bbfmxk37g83a2mmzwa4n6z5li7nbik4d";
    };

    phases = "unpackPhase installPhase";

    installPhase = ''
      copy() {
          mkdir -p $out/share/
          cp -r $@ $out/share/
      }

      copy bin libexec completions plugins pyenv.d

      mkdir -p $out/bin/
      ln -s ../share/libexec/pyenv $out/bin/pyenv
    '';
}
