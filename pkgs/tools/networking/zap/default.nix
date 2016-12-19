{ stdenv, fetchFromGitHub, jre, jdk, ant }:

stdenv.mkDerivation rec {
  name = "zap-${version}";
  version = "2.5.0";
  src = fetchFromGitHub {
    owner = "zaproxy";
    repo = "zaproxy";
    rev ="${version}";
    sha256 = "12bd0f2zrs7cvcyy2xj31m3szxrr2ifdjyd24z047qm465z3hj33";
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
    echo "#!/bin/sh" > "$out/bin/zap"
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
