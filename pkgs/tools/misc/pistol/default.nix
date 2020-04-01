{ stdenv
, buildGoModule
, fetchFromGitHub
, file
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r2nq1zsm9zxl097qnjgr5lk9jm3jjvpgczpvp1nx7dfnahkx2wf";
  };

  modSha256 = "0l4rjrvgbb4b3abyvyz9ws0mh78pri0cvncwv91dzgbx796a2nn6";

  subPackages = [ "cmd/pistol" ];

  buildInputs = [
    file
  ];

  meta = with stdenv.lib; {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
