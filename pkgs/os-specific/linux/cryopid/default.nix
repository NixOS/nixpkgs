{stdenv, fetchurl, zlibStatic}:

let

  pname = "cryopid";
  version = "20090908";
  revision = "7da69201d50e";

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://sharesource.org/hg/cryopid/archive/${revision}.tar.bz2";
    sha256 = "908a4b1cb26322ee25afe13ff59e0d86f669538cb4583766b15ca79fda6c69ca";
  };

  buildInputs = [ zlibStatic ];

  preBuild = "cd src";

  installPhase = "mkdir -p $out/bin; cp cryopid $out/bin";

  meta = {
    description = "A process freezer for Linux";
    longDescription = ''
      CryoPID allows you to capture the state of a running process in Linux
      and save it to a file.  This file can then be used to resume the process
      later on, either after a reboot or even on another machines.
    '';
    homepage = http://sharesource.org/project/cryopid;
    license = ''
      Modified BSD license (without advertising clause).  CryoPID ships with
      and links against the dietlibc library, which is distributed under the
      GNU General Public Licence, version 2.
    '';
  };
}
