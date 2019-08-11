{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  version = "2019-02-13";
  name = "nginx-config-formatter-${version}";

  src = fetchFromGitHub {
    owner = "1connect";
    repo = "nginx-config-formatter";
    rev = "4ea6bbc1bdeb1d28419548aeca90f323e64e0e05";
    sha256 = "0h6pj9i0wim9pzkafi92l1nhlnl2a530vnm7qqi3n2ra8iwfyw4f";
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
