{ stdenv, fetchFromGitHub, awscli, jdk11, maven, ... }:

stdenv.mkDerivation rec {
  name = "okta-aws-${version}";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "oktadeveloper";
    repo = "okta-aws-cli-assume-role";
    rev = "v${version}";
    sha256 = "0dp4ychyqsz9vyplk416xl4x6b7zqf7zsjyybg53rxjw5h85640r";
  };

  buildInputs = [ (maven.override {jdk = jdk11;}) ];

  builder = ./builder.sh;

  postInstall = ''
    export jre=${jdk11}
    export awscli=${awscli}
    substituteAllInPlace $out/bin/withokta
    substituteAllInPlace $out/bin/okta-credential_process
    substituteAllInPlace $out/bin/okta-listroles
  '';

  meta = with stdenv.lib; {
    description = "Okta AWS CLI Assume Role Tool";
    homepage = "https://github.com/oktadeveloper/okta-aws-cli-assume-role";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnarg ];
    platforms = platforms.darwin;
  };
}
