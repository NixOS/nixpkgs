{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, mercurial
, git
}:

buildGoModule rec {
  pname = "hound";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hound-search";
    repo = "hound";
    rev = "v${version}";
    sha256 = "0p5w54fr5xz19ff8k5xkyq3iqhjki8wc0hj2x1pnmk6hzrz6hf65";
  };

  vendorSha256 = "0x1nhhhvqmz3qssd2d44zaxbahj8lh9r4m5jxdvzqk6m3ly7y0b6";

  nativeBuildInputs = [ makeWrapper ];

  # requires network access
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/houndd --prefix PATH : ${lib.makeBinPath [ mercurial git ]}
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Lightning fast code searching made easy";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
