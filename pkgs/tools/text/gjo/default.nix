{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gjo";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "gjo";
    rev = version;
    hash = "sha256-vEk5MZqwAMgqMLjwRJwnbx8nVyF3U2iUz0S3L0GmCh4=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Small utility to create JSON objects";
    homepage = "https://github.com/skanehira/gjo";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
