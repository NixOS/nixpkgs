{ stdenv, fetchurl, fetchpatch, python3, which }:

stdenv.mkDerivation rec {
  name = "fatrace-${version}";
  version = "0.11";

  src = fetchurl {
    url = "http://launchpad.net/fatrace/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "1f77v222nlfbf8fv7d28cnpm7x8xz0mhxavgz19c2jc51pjlv84s";
  };

  patchFlags = "-p0";
  patches = [
    (fetchpatch {
      sha256 = "0gym1zg42vb4czpbkz4shnc7z3lskn1ny6dpx10ykwf145xyf9m2";
      name = "fatrace-fix-crash-when-using-p-option.patch";
      url = "http://bazaar.launchpad.net/~pitti/fatrace/trunk/diff/67?context=3";
    })
  ];

  buildInputs = [ python3 which ];

  postPatch = ''
    substituteInPlace power-usage-report \
      --replace "'which'" "'${which}/bin/which'"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Report system-wide file access events";
    homepage = https://launchpad.net/fatrace/;
    license = licenses.gpl3Plus;
    longDescription = ''
      fatrace reports file access events from all running processes.
      Its main purpose is to find processes which keep waking up the disk
      unnecessarily and thus prevent some power saving.
      Requires a Linux kernel with the FANOTIFY configuration option enabled.
      Enabling X86_MSR is also recommended for power-usage-report on x86.
    '';
    maintainers = with maintainers; [ nckx ];
    platforms = platforms.linux;
  };
}
