{ lib, stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = pname;
    rev = "v${version}";
    sha256 = "uVhftO6AqFnZ0uaEYRAPvVskkouNOXPtNVYXx7WJKyw=";
  };

  propagatedBuildInputs = with python3Packages; [ click distro psutil ];

  doCheck = false;
  pythonImportsCheck = [ "source" ];

  # patch to prevent script copying and to disable install
  patches = [ ./prevent-install-and-copy.patch ];

  postInstall = ''
    # copy script manually
    cp ${src}/scripts/cpufreqctl.sh $out/bin/cpufreqctl
  '';

  meta = with lib; {
    homepage = "https://github.com/AdnanHodzic/auto-cpufreq";
    description = "Automatic CPU speed & power optimizer for Linux";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.Technical27 ];
  };
}
