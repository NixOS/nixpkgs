{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "gradescope_submit";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "nmittu";
    repo = "gradescope-submit";
    rev = version;
    hash = "sha256-BVNXipgw0wz3PRGYvur8jrXZw/6i0fZ+MOZHzXzlFOk=";
  };

  buildInputs = with ocamlPackages; [
    core
    core_unix
    cohttp
    cohttp-lwt-unix
    lambdasoup
    toml
    yojson
    lwt_ssl
  ];

  meta = with lib; {
    description = "A small script to submit to Gradescope via GitHub";
    homepage = "https://github.com/nmittu/gradescope-submit";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "submit";
  };
}
