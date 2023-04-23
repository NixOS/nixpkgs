{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "filtron";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "filtron";
    rev = "v${version}";
    hash = "sha256-RihxlJvbHq5PaJz89NHl/wyXrKjSiC4XYAs7LSKAo6E=";
  };

  vendorHash = "sha256-1DRR16WiBGvhOpq12L5njJJRRCIA7ajs1Py9j/3cWPE=";

  patches = [
    # Update golang version in go.mod
    (fetchpatch {
      url = "https://github.com/asciimoo/filtron/commit/365a0131074b3b12aaa65194bfb542182a63413c.patch";
      hash = "sha256-QGR6YetEzA/b6tC4uD94LBkWv0+9PG7RD72Tpkn2gQU=";
    })
    # Add missing go.sum file
    (fetchpatch {
      url = "https://github.com/asciimoo/filtron/commit/077769282b4e392e96a194c8ae71ff9f693560ea.patch";
      hash = "sha256-BhHbXDKiRjSzC6NKhKUiH6rjt/EgJcEprHMMJ1x/wiQ=";
    })
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Reverse HTTP proxy to filter requests by different rules.";
    homepage = "https://github.com/asciimoo/filtron";
    license = licenses.agpl3;
    maintainers = [ maintainers.dasj19 ];
    platforms = platforms.linux;
  };
}
