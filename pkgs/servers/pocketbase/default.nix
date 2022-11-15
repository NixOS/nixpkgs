{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pocketbase";
  version = "0.7.10";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KQMCWriPJ3fUXjG+uAqOMbR8dZDrlxQ3iDqyYHhC6hI=";
  };

  vendorSha256 = "sha256-i3CRba2HA7dOEh4PU1rNZUl05pZqIm946lIjP7ZcFEc=";

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';

  meta = with lib; {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
