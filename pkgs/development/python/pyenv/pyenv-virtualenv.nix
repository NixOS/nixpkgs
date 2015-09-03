{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
    name = "pyenv-virtualenv-${version}";
    version = "20150719";

    src = fetchurl {
        url = "https://github.com/yyuu/pyenv-virtualenv/archive/v${version}.tar.gz";
        sha256 = "0dqws1x99vn6yd5ca8sblk00yb2y7snqmhvf5w7awkvbcpismyc4";
    };

    phases = "unpackPhase installPhase";

    installPhase = ''
      copy() {
          mkdir -p $out/share/plugins/pyenv-virtualenv
          cp -r $@ $out/share/plugins/pyenv-virtualenv
      }

      copy bin etc
    '';
}
