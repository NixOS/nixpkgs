{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "impl";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = "impl";
    rev = "v${version}";
    sha256 = "0l21fkcgiaaf6ka91dmz8hx0l3nbp0kqi8p25kij1s5zb796z0dy";
  };

  vendorSha256 = "0xkalwy02w62px01jdwwr3vwwsh50f22dsxf8lrrwmw6k0rq57zv";

  # go: cannot find GOROOT directory: go
  doCheck = false;

  meta = with lib; {
    description = "Generate method stubs for implementing an interface";
    homepage = "https://github.com/josharian/impl";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
