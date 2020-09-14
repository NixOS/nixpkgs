{ stdenv, pkgs, buildChromiumExtension }:
with stdenv.lib;
buildChromiumExtension rec {
  pname = "https-everywhere";
  version = "2020.8.13";

  src = pkgs.fetchgit {
    url = "https://github.com/EFForg/https-everywhere.git";
    rev = version;
    sha256 = "0l0xi2ywb9jf3sqjh6d581lh6rpiim018jj8bkwcx2xyidsl309m";
    fetchSubmodules = true;
  };

  buildInputs = [
    pkgs.bash
    pkgs.getopt
    pkgs.python36
  ];

  patchPhase = ''
    # Skip building unneeded artifacts which would require further dependencies or patching.
    sed -i '/$BROWSER/d; /$crx_cws/d; /$crx_eff/d; /$zip/d' ./make.sh
  '';

  buildPhase = ''
    export HOME=$(mktemp -d)
    ${pkgs.bash}/bin/bash -e -o pipefail ./make.sh
  '';

  preInstall = ''
    cd pkg/crx-eff
  '';

  meta = {
    description = "A browser extension that encrypts your communications with many websites that offer HTTPS but still allow unencrypted connections";
    homepage = "https://github.com/EFForg/https-everywhere";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
