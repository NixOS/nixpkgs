{stdenv, fetchFromGitHub, libxml2, file, p7zip, unrar, unzip}:

stdenv.mkDerivation rec {
  name = "rarcrack-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jaredsburrows";
    repo = "Rarcrack";
    rev = "35ead64cd2b967eec3e3e3a4c328b89b11ff32a0";
    sha256 = "134fq84896w5vp8vg4qg0ybpb466njibigyd7bqqm1xydr07qrgn";
  };

  buildInputs = [ libxml2 file p7zip unrar unzip ];
  buildFlags = if stdenv.cc.isClang then [ "CC=clang" ] else null;
  installFlags = "PREFIX=\${out}";

  patchPhase = ''
   substituteInPlace rarcrack.c --replace "file -i" "${file}/bin/file -i"
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with stdenv.lib; {
    description = "This program can crack zip,7z and rar file passwords";
    longDescription = ''
    If you forget your password for compressed archive (rar, 7z, zip), this program is the solution.
    This program uses bruteforce algorithm to find correct password. You can specify wich characters will be used in password generations.
    Warning: Please don't use this program for any illegal things!
    '';
    homepage = https://github.com/jaredsburrows/Rarcrack;
    license = licenses.gpl2;
    maintainers = with maintainers; [ davidak ];
    platforms = with platforms; unix;
  };
}

