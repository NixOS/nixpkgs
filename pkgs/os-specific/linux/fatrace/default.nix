{stdenv, fetchurl, python3}:

stdenv.mkDerivation rec {
  version = "0.9";
  name = "fatrace-${version}";

  src = fetchurl {
    url = "https://launchpad.net/fatrace/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "c028d822ffde68805e5d1f62c4e2d0f4b3d4ae565802cc9468c82b25b92e68cd";
  };

  buildInputs = [ python3 ];

  makeFlagsArray = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Report system-wide file access events";
    homepage = https://launchpad.net/fatrace/;
    license = with licenses; gpl3Plus;
    longDescription = ''
      fatrace reports file access events from all running processes.
      Its main purpose is to find processes which keep waking up the disk
      unnecessarily and thus prevent some power saving.

      Requires a Linux kernel with the FANOTIFY configuration option enabled.
      Enabling X86_MSR is also recommended for power-usage-report on x86.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; linux;
  };
}
