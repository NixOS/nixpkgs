{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pkgtop";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "pkgtop";
    rev = version;
    hash = "sha256-Skk7Zur2UMxNjrJmcp+FvUuNvbh9HmzuZ5mWcvhxcKk=";
  };

  vendorHash = "sha256-dlDbNym7CNn5088znMNgGAr2wBM3+nYv3q362353aLs=";

  postInstall = ''
    mv $out/bin/{cmd,pkgtop}
  '';

  meta = with lib; {
    description = "Interactive package manager and resource monitor designed for the GNU/Linux";
    homepage = "https://github.com/orhun/pkgtop";
    changelog = "https://github.com/orhun/pkgtop/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
