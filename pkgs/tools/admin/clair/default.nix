{ stdenv, buildGoModule, fetchFromGitHub, makeWrapper, rpm, xz, Security }:

buildGoModule rec {
  pname = "clair";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    sha256 = "14dh9iv2g138rivvfk135m3l90kk6c1ln1iqxhbi7s99h1jixbqw";
  };

  modSha256 = "0rgkrid58kji39nlmiii95r8shbzr6dwalj5m7qwxy5w1rcaljr5";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clair \
      --prefix PATH : "${stdenv.lib.makeBinPath [ rpm xz ]}"
  '';

  meta = with stdenv.lib; {
    description = "Vulnerability Static Analysis for Containers";
    homepage = "https://github.com/quay/clair";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
