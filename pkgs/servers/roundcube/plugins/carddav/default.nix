{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "carddav";
  version = "4.3.0";

  src = fetchzip {
    url = "https://github.com/mstilkerich/rcmcarddav/releases/download/v${version}/carddav-v${version}.tar.gz";
    sha256 = "1jk1whx155svfalf1kq8vavn7jsswmzx4ax5zbj01783rqyxkkd5";
  };
}
