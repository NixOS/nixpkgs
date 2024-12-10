{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "present";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "terror";
    repo = pname;
    rev = version;
    sha256 = "+kCHe84ikdCLd7j5YwP2j3xz+XTzzo/kLy+b9YUFDnI=";
  };

  cargoSha256 = "VKY/FQUrFWtLxKoK6LP6qPMqNN4absZvnAbH9mha1fI=";

  # required for tests
  postPatch = ''
    patchShebangs bin/get_version
  '';

  doCheck = true;

  meta = with lib; {
    description = "A script interpolation engine for markdown documents";
    homepage = "https://github.com/terror/present/";
    license = licenses.cc0;
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "present";
  };
}
