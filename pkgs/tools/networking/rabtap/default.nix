{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "rabtap";
  version = "1.42";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${version}";
    sha256 = "sha256-+e8HHd2j8M2EJzfCQtohdlp+24JFZ1kA2/t+VSqFDAI=";
  };

  vendorHash = "sha256-uRlFzhHtpZSie4Fmtj9YUPn+c7+Gvimlk1q8CcXFYmg=";

  meta = with lib; {
    description = "RabbitMQ wire tap and swiss army knife";
    license = licenses.gpl3Only;
    homepage = "https://github.com/jandelgado/rabtap";
    maintainers = with maintainers; [ eigengrau ];
  };
}
