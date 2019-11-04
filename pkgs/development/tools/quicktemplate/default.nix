{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "quicktemplate";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "v${version}";
    sha256 = "08gmaqhb5dcv04i6x5yv0apj72v35ljzpfq5placsw05ji0wlnks";
  };

  modSha256 = "00l0cppi94h7g3ial1xix2qbx2iif6sq5iyby9v0r4mngd1kd9yn";
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/valyala/quicktemplate";
    description = "Fast, powerful, yet easy to use template engine for Go";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
