{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
, pkg-config
, btrfs-progs
, gpgme
, lvm2
}:

buildGoModule rec {
  pname = "dive";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1pmw8pUlek5FlI1oAuvLSqDow7hw5rw86DRDZ7pFAmA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/wagoodman/dive/commit/fe9411c414418d839a8638bb9a12ccfc892b5845.patch";
      sha256 = "sha256-c0TcUQ87CeOiXHoTQ3z/04i72aDr403DL7fIbXTJ9cY=";
    })
  ];

  vendorSha256 = "sha256-YPkEei7d7mXP+5FhooNoMDARQLosH2fdSaLXGZ5C27o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for exploring each layer in a docker image";
    homepage = "https://github.com/wagoodman/dive";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam spacekookie SuperSandro2000 ];
  };
}
