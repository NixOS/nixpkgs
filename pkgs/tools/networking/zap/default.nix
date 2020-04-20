{ stdenv, fetchFromGitHub, jdk, ant, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "zap";
  version = "2.7.0";
  src = fetchFromGitHub {
    owner = "zaproxy";
    repo = "zaproxy";
    rev =version;
    sha256 = "1bz4pgq66v6kxmgj99llacm1d85vj8z78jlgc2z9hv0ha5i57y32";
  };

  buildInputs = [ jdk ant ];

  buildPhase = ''
    cd build
    echo -n "${version}" > version.txt
    ant -f build.xml setup init  compile dist copy-source-to-build package-linux
  '';

  installPhase = ''
    mkdir -p "$out/share"
    tar xvf  "ZAP_${version}_Linux.tar.gz" -C "$out/share/"
    mkdir -p "$out/bin"
    echo "#!${runtimeShell}" > "$out/bin/zap"
    echo \"$out/share/ZAP_${version}/zap.sh\" >> "$out/bin/zap"
    chmod +x "$out/bin/zap"
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.owasp.org/index.php/ZAP";
    description = "Java application for web penetration testing";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
