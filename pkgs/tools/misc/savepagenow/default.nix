{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "savepagenow";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "pastpages";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lz6rc47cds9rb35jdf8n13gr61wdkh5jqzx4skikm1yrqkwjyhm";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    requests
  ];

  # requires network access
  doCheck = false;

  meta = with lib; {
    description = "A simple Python wrapper for archive.org's \"Save Page Now\" capturing service";
    homepage = "https://github.com/pastpages/savepagenow";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "savepagenow";
  };
}
