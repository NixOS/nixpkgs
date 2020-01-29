{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "ion";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "redox-os";
    repo = "ion";
    rev = version;
    sha256 = "0i0acl5nw254mw8dbfmb4792rr71is98a5wg32yylfnlrk7zlf8z";
  };

  cargoSha256 = "1hs01b1rhbpafxlhw661k907rznqhcgyng85njkb99bg4lxwxaap";

  meta = with stdenv.lib; {
    description = "Modern system shell with simple (and powerful) syntax";
    homepage = https://github.com/redox-os/ion;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };

  passthru = {
	  shellPath = "/bin/ion";
  };
}
