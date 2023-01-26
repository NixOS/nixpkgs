{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, libxml2
, openssl
, stdenv
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "hurl";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Orange-OpenSource";
    repo = pname;
    rev = version;
    sha256 = "sha256-CQDyIGUIijNphOVo+aYZ7SqkxE4md9+H3D/g7jdqV+M=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libxml2
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    curl
  ];

  # Tests require network access to a test server
  doCheck = false;

  cargoSha256 = "sha256-wNiEULv+0WlZruxibcKqsw4Ym3retwjoGKXxzACcEeA=";

  postInstall = ''
    installManPage docs/manual/hurl.1 docs/manual/hurlfmt.1
  '';

  meta = with lib; {
    description = "Command line tool that performs HTTP requests defined in a simple plain text format.";
    homepage = "https://hurl.dev/";
    changelog = "https://github.com/Orange-OpenSource/hurl/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ eonpatapon figsoda ];
    license = licenses.asl20;
  };
}
