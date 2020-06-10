{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule {
  pname = "red";
  version = "unstable-2019-04-04";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "red";
    rev = "0bfb499760f391d09c6addec2527b0f77eaacdd6";
    sha256 = "0i8f8ih3z97zzbkjkwy4y8z75izm1fscq0rr1g77q7z3kz1lrgrx";
  };

  vendorSha256 = "0640x6p5hi7yp001cw13z5a17bi9vgd3gij5fxa1y06d3848cv7l";

  meta = {
    description = "Terminal log analysis tools";
    homepage = "https://github.com/antonmedv/red";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tv ];
    platforms = lib.platforms.linux;
  };
}
