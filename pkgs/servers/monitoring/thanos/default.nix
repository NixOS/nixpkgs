{ stdenv, runCommandNoCC, makeWrapper, buildGoModule, fetchFromGitHub, bazaar }:
let
  bazaarNoCertValidation =
    runCommandNoCC "bzr-no-cert-validation" {
      inherit bazaar;
      buildInputs = [ makeWrapper ];
    } "makeWrapper $bazaar/bin/bzr $out/bin/bzr --add-flags -Ossl.cert_reqs=none";
in
buildGoModule rec {
  pname = "thanos";
  version = "0.5.0-rc.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "improbable-eng";
    repo = "thanos";
    sha256 = "1m7jj5g7s4c7nhbyc6vwn08ripp4d3ciim48siillwhm90gbphrw";
  };

  overrideModAttrs = oldAttrs : {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      bazaarNoCertValidation
    ];
  };

  modSha256 = "1236cg00h8077fmvyddwjsnw85r69ac18b2chcpgzd85xdcaxavk";

  subPackages = "cmd/thanos";

  buildFlagsArray = let t = "github.com/prometheus/common/version"; in ''
    -ldflags=
       -X ${t}.Version=${version}
       -X ${t}.Revision=unknown
       -X ${t}.Branch=unknown
       -X ${t}.BuildUser=nix@nixpkgs
       -X ${t}.BuildDate=unknown
  '';

  meta = with stdenv.lib; {
    description = "Highly available Prometheus setup with long term storage capabilities";
    homepage = https://github.com/improbable-eng/thanos;
    license = licenses.asl20;
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.unix;
  };
}
