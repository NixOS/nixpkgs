{ stdenv
, fetchFromGitHub
, python3
, which
}:

stdenv.mkDerivation rec {
  pname = "fatrace";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = pname;
    rev = version;
    sha256 = "0lxfqin2bw9235yah8ylb4p8lc3755050sjg30z3gy7bab0lfyg9";
  };

  buildInputs = [ python3 which ];

  postPatch = ''
    substituteInPlace power-usage-report \
      --replace "'which'" "'${which}/bin/which'"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Report system-wide file access events";
    homepage = "https://github.com/martinpitt/fatrace";
    license = licenses.gpl3Plus;
    longDescription = ''
      fatrace reports file access events from all running processes.
      Its main purpose is to find processes which keep waking up the disk
      unnecessarily and thus prevent some power saving.
      Requires a Linux kernel with the FANOTIFY configuration option enabled.
      Enabling X86_MSR is also recommended for power-usage-report on x86.
    '';
    platforms = platforms.linux;
  };
}
