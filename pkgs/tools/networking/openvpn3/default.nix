{ lib
, stdenv
, fetchFromGitHub

# buildtime
, autoreconfHook
, autoconf-archive
, docutils
, jinja2
, git
, pkg-config
, lz4
, jsoncpp
, glib
, libuuid
, libcap_ng
, openssl
, tinyxml-2

# runtime
, python3
}:

stdenv.mkDerivation rec {
  pname = "openvpn3";
  version = "17_beta";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    rev = "v${version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    sha256 = "0cfb1zffrgwlgvwlxv48051w31hyyv5yfnbvy494axp0a8fw9dpl";
    postFetch = ''
      cd "$out"

      substituteInPlace "./update-version-m4.sh" \
        --replace '$(git describe --always --tags)' "v${version}"

      patchShebangs ./openvpn3-core/scripts/version

      ./update-version-m4.sh
      ./openvpn3-core/scripts/version | tee ./openvpn3-core-version

      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    docutils
    jinja2
    pkg-config
  ];

  buildInputs = [
    lz4
    jsoncpp
    glib
    libuuid
    libcap_ng
    openssl
    tinyxml-2
  ];

  propagatedbuildinputs = [
    python3
  ];

  configureFlags = [ "--disable-selinux-build" ];

  NIX_LDFLAGS = "-lpthread";

  meta = with lib; {
    description = "OpenVPN 3 Linux client";
    license = licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
