{ fetchFromGitHub, stdenv, writeText, perl, openssh, rsync, logger,
  configFile ? "/etc/rsnapshot.conf" }:

let patch = writeText "rsnapshot-config.patch" ''
--- rsnapshot-program.pl	2013-10-05 20:31:08.715991442 +0200
+++ rsnapshot-program.pl	2013-10-05 20:31:42.496193633 +0200
@@ -383,7 +383,7 @@
 	}
 	
 	# set global variable
-	$config_file = $default_config_file;
+	$config_file = '${configFile}';
 }
 
 # accepts no args
'';
in
stdenv.mkDerivation rec {
  name = "rsnapshot-1.4git";
  src = fetchFromGitHub {
    owner = "DrHyde";
    repo = "rsnapshot";
    rev = "1047cbb57937c29233388e2fcd847fecd3babe74";
    sha256 = "173y9q89dp4zf7nysqhjp3i2m086n7qdpawb9vx0ml5zha6mxf2p";
  };

  propagatedBuildInputs = [perl openssh rsync logger];

  patchPhase = ''
    substituteInPlace "Makefile.in" --replace \
      "/usr/bin/pod2man" "${perl}/bin/pod2man"
    patch -p0 <${patch}
  '';

  # I still think this is a good idea, but it currently fails in the chroot because it checks
  # that things are writable and so on.
  #checkPhase = ''
  #  if [ -f "${configFile}" ]
  #  then
  #    ${perl}/bin/perl -w ./rsnapshot configtest
  #  else
  #    echo File "${configFile}" does not exist, not checking
  #  fi
  #'';

  meta = with stdenv.lib; {
    description = "A filesystem snapshot utility for making backups of local and remote systems";
    homepage = http://rsnapshot.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
