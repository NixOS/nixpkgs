{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bunnyfetch";
  version = "unstable-2021-06-19";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "bunnyfetch";
    rev = "24370338b936bae1ebdefea73e8372ac0b4d2858";
    sha256 = "09wcffx6ak4djm2lrxq43n27p9qmczng4rf11qpwx3w4w67jvpz9";
  };

  vendorSha256 = "1vv69y0x06kn99lw995sbkb7vgd0yb18flkr2ml8ss7q2yvz37vi";

  # No upstream tests
  doCheck = false;

  meta = with lib; {
    description = "Tiny system info fetch utility";
    homepage = "https://github.com/Rosettea/bunnyfetch";
    license = licenses.mit;
    maintainers = with maintainers; [ devins2518 ];
    platforms = platforms.linux;
    mainProgram = "bunnyfetch";
  };
}
