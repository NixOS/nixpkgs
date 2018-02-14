{ stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  version = "2017-07-26";
  name = "nginx-config-formatter-${version}";

  src = fetchFromGitHub {
    owner = "1connect";
    repo = "nginx-config-formatter";
    rev = "f5a26225bd7ad5ea97fc6f681cc66fef2f43d5b6";
    sha256 = "1wm6dfn797fdwjp6cpy70ngws6m9bh64xi1vinm43b3qms81cnb9";
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
