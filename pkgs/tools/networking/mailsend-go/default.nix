{ lib, fetchFromGitHub, gitUpdater, buildGoModule }:
let
  pname = "mailsend-go";

  version = "1.0.10";

  owner = "muquit";

  rev-prefix = "v";

  url = "https://github.com/${owner}/${pname}";
in

buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "${rev-prefix}${version}";
    hash = "sha256-0coNy7gUhnC9LFVYUrgecmnwq7yW2UzisWc9iQdnh/Q=";
  };

  vendorHash = "sha256-Y6aAeMvQtWrTWHeNPymbUvwFQbEgdHy2DWm6emtZuxg=";

  passthru.updateScript = gitUpdater {
    inherit url rev-prefix;
  };

  meta = with lib; {
    description = "Multi-platform command line tool to send mail via SMTP protocol";
    homepage = url;
    changelog = "https://raw.githubusercontent.com/${owner}/${pname}/${rev-prefix}${version}/ChangeLog.md";
    license = licenses.mit;
    maintainers = [ maintainers.jsoo1 ];
    platforms = platforms.all;
  };
}
