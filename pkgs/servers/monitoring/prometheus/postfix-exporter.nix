{ stdenv, buildGoPackage, fetchFromGitHub, systemd, makeWrapper }:

buildGoPackage rec {
  name = "postfix_exporter-${version}";
  version = "0.1.1";

  goPackagePath = "github.com/kumina/postfix_exporter";

  src = fetchFromGitHub {
    owner = "kumina";
    repo = "postfix_exporter";
    rev = version;
    sha256 = "1p2j66jzzgyv2w832pw57g02vrac6ldrblqllgwyy0i8krb3ibyz";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ systemd ];

  goDeps = ./postfix-exporter-deps.nix;

  postInstall = ''
    wrapProgram $bin/bin/postfix_exporter \
      --prefix LD_LIBRARY_PATH : "${systemd.lib}/lib"
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A Prometheus exporter for Postfix";
    license = licenses.asl20;
    maintainers = with maintainers; [ willibutz ];
  };
}
