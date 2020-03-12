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

  cargoSha256 = "0f266kygvw2id771g49s25qsbqb6a0gr1r0czkcj96n5r0wg8wrn";

  meta = with stdenv.lib; {
    description = "Modern system shell with simple (and powerful) syntax";
    homepage = https://github.com/redox-os/ion;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
    # This has not had a release since 2017, and no longer compiles with the
    # latest Rust compiler.
    broken = false;
  };

  passthru = {
    shellPath = "/bin/ion";
  };
}
