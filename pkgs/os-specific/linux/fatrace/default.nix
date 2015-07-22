{ stdenv, fetchurl, python3, which }:

let version = "0.10"; in
stdenv.mkDerivation rec {
  name = "fatrace-${version}";

  src = fetchurl {
    url = "http://launchpad.net/fatrace/trunk/${version}/+download/${name}.tar.bz2";
    sha256 = "0q0cv2bsgf76wypz18v2acgj1crcdqhrhlsij3r53glsyv86xyra";
  };

  buildInputs = [ python3 which ];

  postPatch = ''
    substituteInPlace power-usage-report \
      --replace "'which'" "'${which}/bin/which'"
  '';

  makeFlagsArray = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    inherit version;
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
    platforms = with platforms; linux;
  };
}
