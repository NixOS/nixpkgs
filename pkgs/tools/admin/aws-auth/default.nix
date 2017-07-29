{ stdenv, fetchFromGitHub, makeWrapper, jq, awscli }:

stdenv.mkDerivation rec {
  version = "unstable-2017-07-24";
  name = "aws-auth-${version}";

  src = fetchFromGitHub {
    owner = "alphagov";
    repo = "aws-auth";
    rev = "5a4c9673f9f00ebaa4bb538827e1c2f277c475e1";
    sha256 = "095j9zqxra8hi2iyz0y4azs9yigy5f6alqkfmv180pm75nbc031g";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  # copy script and set $PATH
  installPhase = ''
    install -D $src/aws-auth.sh $out/bin/aws-auth
    wrapProgram $out/bin/aws-auth \
      --prefix PATH : ${stdenv.lib.makeBinPath [ awscli jq ]}
  '';

  meta = {
    homepage = https://github.com/alphagov/aws-auth;
    description = "AWS authentication wrapper to handle MFA and IAM roles";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ris ];
  };
}
