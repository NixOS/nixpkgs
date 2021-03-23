{ lib
, buildGoModule
, fetchFromGitHub
, git
, stdenv
}:

buildGoModule rec {
  pname = "gitjacker";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "gitjacker";
    rev = "v${version}";
    sha256 = "sha256-cMjjVjHGTVT33bknAo2DVH/qPSeazVIIw3RpXGDxF5E=";
  };

  vendorSha256 = null;

  propagatedBuildInputs = [ git ];

  checkInputs = [ git ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export PATH=$TMPDIR/usr/bin:$PATH
  '';

  meta = with lib; {
    description = "Leak git repositories from misconfigured websites";
    longDescription = ''
      Gitjacker downloads git repositories and extracts their contents
      from sites where the .git directory has been mistakenly uploaded.
      It will still manage to recover a significant portion of a repository
      even where directory listings are disabled.
    '';
    homepage = "https://github.com/liamg/gitjacker";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ fab ];
  };
}
