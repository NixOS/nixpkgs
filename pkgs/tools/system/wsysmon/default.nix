{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, cmake
, pkg-config
, gtkmm3
, gtk3
, procps
, spdlog
}:

stdenv.mkDerivation rec {
  pname = "wsysmon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "slyfabi";
    repo = "wsysmon";
    rev = version;
    sha256 = "sha256-5kfZT+hm064qXoAzi0RdmUqXi8VaXamlbm+FJOrGh3A=";
  };

  patches = [
    # Prevent CMake from trying to fetch libraries from GitHub
    (substituteAll {
      src = ./dependencies.patch;
      spdlog_src = spdlog.src;
    })
    # Add an installPhase
    ./install.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtkmm3
    gtk3
    procps
    spdlog
  ];

  meta = with lib; {
    description = "A windows task manager clone for Linux";
    homepage = "https://github.com/SlyFabi/WSysMon";
    license = [ licenses.mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ totoroot ];
  };
}
