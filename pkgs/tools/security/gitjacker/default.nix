{ lib
, buildGoModule
, fetchFromGitHub
, git
, stdenv
}:

buildGoModule rec {
  pname = "gitjacker";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "gitjacker";
    rev = "v${version}";
    sha256 = "0fg95i2y8sj7dsvqj8mx0k5pps7d0h1i4a3lk85l8jjab4kxx8h9";
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
