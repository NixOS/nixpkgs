{ pkgs, ... }:

pkgs.buildGoModule rec {
  pname = "vouch-proxy";
  version = "0.23.1";

  nativeBuildInputs = [ pkgs.makeWrapper ];

  src = pkgs.fetchFromGitHub {
    owner = "vouch";
    repo = "vouch-proxy";
    rev = "v0.23.1";
    sha256 = "00nraynyscaxns3c6lpwq7pscflhj87yzy6474biqbp04qyn3m36";
  };

  vendorSha256 = "1yiagqg0x6n8mail0zz4400bpjvz49kbncm5km2nhapx6znzvghm";

  doCheck = false;

  # Vouch-proxy expects these static files to be either in the same directory as
  # the root or in the directory pointed to by `VOUCH_ROOT`.  We choose to put the
  # static files in the immutable nix store and set the env var accordingly.
  #
  # Note that `VOUCH_ROOT` is also used as the base path for the JWT secret
  # file, which vouch-proxy will try to autogenerate if it's not otherwise
  # configured.  Now that we've made `VOUCH_ROOT` immutable that will fail.
  #
  # You must set `VOUCH_JWT_SECRET` or the equivalent YAML config to avoid
  # trouble.
  postInstall = ''
    cp -r static/ templates/ $out
    wrapProgram "$out/bin/vouch-proxy" --set VOUCH_ROOT "$out"
  '';

  meta = with pkgs.lib; {
    description = "Vouch-proxy is an SSO and OAuth / OIDC login solution for Nginx using the auth_request module";
    license = licenses.mit;
  };
}
