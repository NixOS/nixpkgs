{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, mercurial
, git
}:

buildGoModule rec {
  pname = "hound";
  version = "unstable-2021-01-26";

  src = fetchFromGitHub {
    owner = "hound-search";
    repo = "hound";
    rev = "b88fc1f79d668e6671a478ddf4fb3e73a63067b9";
    sha256 = "00xc3cj7d3klvhsh9hivvjwgzb6lycw3r3w7nch98nv2j8iljc44";
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
