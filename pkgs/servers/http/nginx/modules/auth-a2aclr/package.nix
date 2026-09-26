{
  fetchFromGitLab,
  lib,
  mkNginxPlugin,
  arpa2common,
}:

mkNginxPlugin (finalAttrs: {
  pname = "auth-a2aclr";
  version = "0-unstable-2020-08-03";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "nginx-auth-a2aclr";
    rev = "bbabf9480bb2b40ac581551883a18dfa6522dd63";
    hash = "sha256-h2LgMhreCgod+H/bNQzY9BvqG9ezkwikwWB3T6gHH04=";
  };

  buildInputs = [
    (arpa2common.overrideAttrs (old: rec {
      version = "0.7.1";

      src = fetchFromGitLab {
        owner = "arpa2";
        repo = "arpa2common";
        rev = "v${version}";
        hash = "sha256-8zVsAlGtmya9EK4OkGUMu2FKJRn2Q3bg2QWGjqcii64=";
      };
    }))
  ];

  meta = {
    broken = true; # overridden arpa2common package fails to build
    description = "Integrate ARPA2 Resource ACLs into nginx";
    homepage = "https://gitlab.com/arpa2/nginx-auth-a2aclr";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
})
