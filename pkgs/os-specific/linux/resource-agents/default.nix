{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, python3
, glib
}:

stdenv.mkDerivation rec {
  pname = "resource-agents";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:1mdrwr3yqdqaifh3ynnhzdc59yfn4x00iygxqvh33p53jgf7cqir";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    python3
  ];

  meta = with lib; {
    homepage = "https://github.com/ClusterLabs/resource-agents";
    description = "Combined repository of OCF agents from the RHCS and Linux-HA projects";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ryantm ];
  };
}
