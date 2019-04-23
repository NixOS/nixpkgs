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
  version = "0.4.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "improbable-eng";
    repo = "thanos";
    sha256 = "0md9m7swmxh0sg6vf169iw3p6jc1hxzgylirh6vs1q0frz21y47j";
  };

  overrideModAttrs = oldAttrs : {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      bazaarNoCertValidation
    ];
  };

  modSha256 = "0sr9g95qab7x46m3mpahpb2xgzdbpy6p0kn6gq1s5phg2xxj2w00";

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
