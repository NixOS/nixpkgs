{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtkmm3,
  gtk3,
  procps,
  spdlog,
}:

stdenv.mkDerivation rec {
  pname = "wsysmon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "slyfabi";
    repo = "wsysmon";
    rev = version;
    hash = "sha256-5kfZT+hm064qXoAzi0RdmUqXi8VaXamlbm+FJOrGh3A=";
  };

  patches = [
    # Dynamically link spdlog
    ./dependencies.patch
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
    description = "Windows task manager clone for Linux";
    homepage = "https://github.com/SlyFabi/WSysMon";
    license = [ licenses.mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ totoroot ];
    mainProgram = "WSysMon";
  };
}
