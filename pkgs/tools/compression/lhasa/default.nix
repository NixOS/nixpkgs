{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lhasa-0.3.1";
  src = fetchurl {
    url = https://soulsphere.org/projects/lhasa/lhasa-0.3.1.tar.gz;
    sha256 = "092zi9av18ma20c6h9448k0bapvx2plnp292741dvfd9hmgqxc1z";
  };
  meta = {
    description = "Free Software replacement for the Unix LHA tool";
    longDescription = ''
      Lhasa is a Free Software replacement for the Unix LHA tool, for
      decompressing .lzh (LHA / LHarc) and .lzs (LArc) archives. The backend for
      the tool is a library, so that it can be reused for other purposes.
    '';
    license = stdenv.lib.licenses.isc;
    homepage = http://fragglet.github.io/lhasa;
    maintainers = with stdenv.lib; [ maintainers.sander ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
