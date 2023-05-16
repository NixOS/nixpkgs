<<<<<<< HEAD
{ lib, buildGraalvmNativeImage, fetchurl }:

buildGraalvmNativeImage rec {
  pname = "zprint";
  version = "1.2.7";

  src = fetchurl {
    url = "https://github.com/kkinnear/${pname}/releases/download/${version}/${pname}-filter-${version}";
    sha256 = "sha256-C2WEzF7Xl37/LDlk6f77/WcWNadE0zAfzxEw+RTRGto=";
=======
{ lib, buildGraalvmNativeImage, fetchurl  }:

buildGraalvmNativeImage rec {
  pname = "zprint";
  version = "1.2.5";

  src = fetchurl {
    url = "https://github.com/kkinnear/${pname}/releases/download/${version}/${pname}-filter-${version}";
    sha256 = "sha256-PWdR5jqyzvTk9HoxqDldwtZNik34dmebBtZZ5vtva4A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  extraNativeImageBuildArgs = [
    "--no-server"
    "-H:EnableURLProtocols=https,http"
    "-H:+ReportExceptionStackTraces"
    "--report-unsupported-elements-at-runtime"
    "--initialize-at-build-time"
    "--no-fallback"
  ];

  meta = with lib; {
    description = "Clojure/EDN source code formatter and pretty printer";
    longDescription = ''
      Library and command line tool providing a variety of pretty printing capabilities
      for both Clojure code and Clojure/EDN structures. It can meet almost anyone's needs.
      As such, it supports a number of major source code formatting approaches
    '';
    homepage = "https://github.com/kkinnear/zprint";
    license = licenses.mit;
    maintainers = with maintainers; [ stelcodes ];
<<<<<<< HEAD
    mainProgram = "zprint";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
