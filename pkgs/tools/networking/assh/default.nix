{ stdenv, buildGoModule, fetchFromGitHub, openssh, makeWrapper }:

buildGoModule rec {
  pname = "assh";
  version = "2.10.0";

  src = fetchFromGitHub {
    repo = "advanced-ssh-config";
    owner = "moul";
    rev = "v${version}";
    sha256 = "0qsb5p52v961akshgs1yla2d7lhcbwixv2skqaappdmhj18a23q2";
  };

  vendorSha256 = "03ycjhal4g7bs9fhzrq01ijj48czvs272qcqkd9farsha5gf0q0b";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/assh" \
      --prefix PATH : ${openssh}/bin
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/assh --help > /dev/null
  '';

  meta = with stdenv.lib; {
    description = "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts";
    homepage = "https://github.com/moul/assh";
    changelog = "https://github.com/moul/assh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ zzamboni ];
    platforms = with platforms; linux ++ darwin;
  };
}
