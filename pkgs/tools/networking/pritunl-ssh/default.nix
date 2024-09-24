{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname   = "pritunl-ssh";
  version = "1.0.3219.78";

  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-zero-client";
    rev = version;
    sha256 = "sha256-ksTfgt1AWs8hgUR9w6aWv5MDXeORgYNWYZgAFUqj++s=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    install ssh_client.py $out/bin/pritunl-ssh
    install ssh_host_client.py $out/bin/pritunl-ssh-host
  '';

  meta = with lib; {
    description = "Pritunl Zero SSH client";
    homepage = "https://github.com/pritunl/pritunl-zero-client";
    license = licenses.unfree;
    maintainers = with maintainers; [ Thunderbottom ];
    platforms = platforms.unix;
  };
}
