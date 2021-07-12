{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname   = "pritunl-ssh";
  version = "1.0.1674.4";

  src = fetchFromGitHub {
    owner = "pritunl";
    repo = "pritunl-zero-client";
    rev = version;
    sha256 = "07z60lipbwm0p7s2bxcij21jid8w4nyh6xk2qq5qdm4acq4k1i88";
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
