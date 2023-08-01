{
  buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "nhost";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "nhost";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-mjhNZwbYc5RKxDBMmXCllKhHNJYwau5rQABUjKYIkf0=";
  };

  vendorSha256 = null;

  postInstall = ''
    mv $out/bin/cli $out/bin/nhost
  '';

  meta = with lib; {
    description = "The Nhost CLI is used to get a local development environment";
    homepage = "https://github.com/nhost/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ andr-ec ];
  };
}
