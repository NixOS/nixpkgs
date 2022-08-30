{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mdfmt";
  version = "unstable-20181128";

  src = fetchFromGitHub {
    owner = "moorereason";
    repo = "mdfmt";
    rev = "29e3d55cbe5af4cfc31b172aed1d69b9a5a22c5b";
    sha256 = "122k9rjm4g0cksgg1pywm3q64qhgvyq2275mrszjcp4ry15kpd74";
  };

  vendorSha256 = "sha256-hNlVSelaU0DAfeRfz4qfXfmXeBIoWlf57S58jwE6/Zk=";

  meta = with lib; {
    description = "Like gofmt, but for Markdown with front matter";
    homepage = "https://github.com/moorereason/mdfmt";
    license = licenses.mit;
    maintainers = with maintainers; [ Ob11stan ];
  };
}
