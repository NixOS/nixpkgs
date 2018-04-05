{ stdenv, fetchFromGitHub, makeWrapper, jq, awscli, openssl }:

stdenv.mkDerivation rec {
  version = "unstable-2018-04-04";
  name = "aws-auth-${version}";

  src = fetchFromGitHub {
    owner = "alphagov";
    repo = "aws-auth";
    rev = "03e3eb2a0e89c6d55f0721462a6bc077aa4668bf";
    sha256 = "0r89kvkcjsz6v9r2pk45v82v623y334b0hfvdvzfnls3j7d23m2p";
  };

  nativeBuildInputs = [ makeWrapper ];

  # copy script and set $PATH
  installPhase = ''
    install -D $src/aws-auth.sh $out/bin/aws-auth
    wrapProgram $out/bin/aws-auth \
      --prefix PATH : ${stdenv.lib.makeBinPath [ awscli jq openssl ]}
  '';

  meta = {
    homepage = https://github.com/alphagov/aws-auth;
    description = "AWS authentication wrapper to handle MFA and IAM roles";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ris ];
  };
}
