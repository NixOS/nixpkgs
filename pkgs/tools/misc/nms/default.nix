{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nms";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "bartobri";
    repo = "no-more-secrets";
    rev = "v${version}";
    sha256 = "1zfv4qabikf8w9winsr4brxrdvs3f0d7xvydksyx8bydadsm2v2h";
  };

  buildFlags = [ "nms" "sneakers" ];
  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/bartobri/no-more-secrets";
    description = ''
      A command line tool that recreates the famous data decryption
      effect seen in the 1992 movie Sneakers.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.infinisil ];
    platforms = platforms.unix;
  };
}
