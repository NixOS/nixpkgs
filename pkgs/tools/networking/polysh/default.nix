{ stdenv, fetchurl, python2Packages }:

let
  inherit (python2Packages) buildPythonApplication;
in
buildPythonApplication rec {
  name = "polysh-${version}";
  version = "0.4";
  src = fetchurl {
          url = "http://guichaz.free.fr/polysh/files/${name}.tar.bz2";
          sha256 = "0kxhp38c8a8hc8l86y53l2z5zpzxc4b8lx5zyzmq1badcrfc4mh4";
        };

  meta = with stdenv.lib; {
    description = "A tool to aggregate several remote shells into one";
    longDescription = ''
      Polysh is a tool to aggregate several remote shells into one. It
      is used to launch an interactive remote shell on many machines
      at once.
    '';
    maintainers = [ maintainers.astsmtl ];
    homepage = http://guichaz.free.fr/polysh/;
    license = licenses.gpl2;
  };
}
