{ lib, python3, fetchFromGitHub, nixosTests, wrapGAppsNoGuiHook, gobject-introspection, glib }:

python3.pkgs.buildPythonApplication rec {
  pname = "targetcli";
  version = "2.1.58";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    hash = "sha256-9QYo7jGk9iWr26j0qPQCqYsJ+vLXAsO4Xs7+7VT9/yc=";
  };

  nativeBuildInputs = [ wrapGAppsNoGuiHook gobject-introspection ];
  buildInputs = [ glib ];

  propagatedBuildInputs = with python3.pkgs; [ configshell rtslib pygobject3 ];

  postInstall = ''
    install -D targetcli.8 -t $out/share/man/man8/
    install -D targetclid.8 -t $out/share/man/man8/
  '';

  passthru.tests = {
    inherit (nixosTests) iscsi-root;
  };

  meta = with lib; {
    description = "Command shell for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/targetcli-fb";
    license = licenses.asl20;
    maintainers = lib.teams.helsinki-systems.members;
    platforms = platforms.linux;
  };
}
