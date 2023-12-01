{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "rabtap";
  version = "1.39.0";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "rabtap";
    rev = "v${version}";
    sha256 = "sha256-/inclOpKYlEGSEH390+GtRiHXotaH+VxqWVAWSf61Xs=";
  };

  vendorHash = "sha256-BrpDafEFDrH243zDHY9EtkVjPvwrmbJVu5TQMHHOWfA=";

  meta = with lib; {
    description = "RabbitMQ wire tap and swiss army knife";
    license = licenses.gpl3Only;
    homepage = "https://github.com/jandelgado/rabtap";
    maintainers = with maintainers; [ eigengrau ];
  };
}
