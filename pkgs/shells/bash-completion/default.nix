{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bash-completion-2.1";

  src = fetchurl {
    url = "http://bash-completion.alioth.debian.org/files/${name}.tar.bz2";
    sha256 = "0kxf8s5bw7y50x0ksb77d3kv0dwadixhybl818w27y6mlw26hq1b";
  };

  patches = [ ./bash-4.3.patch ];

  doCheck = true;

  # nmcli is included in the network-manager package
  postInstall = ''
    rm $out/share/bash-completion/completions/nmcli
  '';

  meta = {
    homepage = "http://bash-completion.alioth.debian.org/";
    description = "Programmable completion for the bash shell";
    license = "GPL";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
