{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  version = "2016-06-16";
  name = "nginx-config-formatter-${version}";

  src = fetchFromGitHub {
    owner = "1connect";
    repo = "nginx-config-formatter";
    rev = "fe5c77d2a503644bebee2caaa8b222c201c0603d";
    sha256 = "0akpkbq5136k1i1z1ls6yksis35hbr70k8vd10laqwvr1jj41bga";
  };

  buildInputs = [ python3 ];

  doCheck = true;
  checkPhase = ''
    python3 $src/test_nginxfmt.py
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 $src/nginxfmt.py $out/bin/nginxfmt
  '';

  meta = with stdenv.lib; {
    description = "nginx config file formatter";
    maintainers = with maintainers; [ Baughn ];
    license = licenses.asl20;
    homepage = https://github.com/1connect/nginx-config-formatter;
  };
}
