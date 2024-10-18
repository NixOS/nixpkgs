{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "castnow";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "xat";
    repo = "castnow";
    rev = "v${version}";
    hash = "sha256-vAjeDPH+Lu/vj3GhwytXqpbSkg5hKpXsMRNV+8TUeio=";
  };

  npmDepsHash = "sha256-1cLuti3JHpMHn1sno8gE8Ko+eoUWCqFUfIDIBAS+M34=";

  dontNpmBuild = true;

  meta = {
    description = "Command-line Chromecast player";
    homepage = "https://github.com/xat/castnow";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "castnow";
  };
}
