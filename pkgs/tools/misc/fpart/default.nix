{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fpart-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "http://contribs.martymac.org/fpart/${name}.tar.gz";
    sha256 = "1p0ajmry18lcg82znfp8nxs4w3izic775l7df08hywlq4vfa66pg";
  };

  postInstall = ''
    sed "s|^FPART_BIN=.*|FPART_BIN=\"$out/bin/fpart\"|" \
        -i "$out/bin/fpsync"
  '';

  meta = with stdenv.lib; {
    description = "Split file trees into bags (called \"partitions\")";
    longDescription = ''
      Fpart is a tool that helps you sort file trees and pack them into bags
      (called "partitions").

      It splits a list of directories and file trees into a certain number of
      partitions, trying to produce partitions with the same size and number of
      files. It can also produce partitions with a given number of files or a
      limited size.

      Once generated, partitions are either printed as file lists to stdout
      (default) or to files. Those lists can then be used by third party programs.

      Fpart also includes a live mode, which allows it to crawl very large
      filesystems and produce partitions in live. Hooks are available to act on
      those partitions (e.g. immediatly start a transfer using rsync(1))
      without having to wait for the filesystem traversal job to be finished.
      Used this way, fpart can be seen as a powerful data migration tool.
    '';
    homepage = "http://contribs.martymac.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
