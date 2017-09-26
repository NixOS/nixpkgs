{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.10.9";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = "v${version}";
    sha256 = "1shry7dqcbb5d3hp9xz5l3jx9a6i18wssz3m28kpjf3cks427v55";
  };

  patches = [
    # This header was added in 0.10.9 and was since reverted but no new release made
    # remove this patch when updating to next release
    (fetchpatch {
      url = "https://github.com/mholt/caddy/commit/d267b62fe9fdd008f13774afc72d95335934d133.patch";
      name = "revert-sponsors-header.patch";
      sha256 = "192g23kzkrwgif7ii9c70mh1a25gwhm1l1mzyqm9i0d3jifsfc2j";
    })
  ];

  buildFlagsArray = ''
    -ldflags=
      -X github.com/mholt/caddy/caddy/caddymain.gitTag=v${version}
  '';

  meta = with stdenv.lib; {
    homepage = https://caddyserver.com;
    description = "Fast, cross-platform HTTP/2 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem fpletz zimbatm ];
  };
}
