{ stdenv, fetchFromGitHub, pythonPackages, openssh, gnupg, unbound, libreswan }:

let
  inherit (pythonPackages) python;
in stdenv.mkDerivation rec {
  pname    = "hash-slinger";
  name    = "${pname}-${version}";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "letoams";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "05wn744ydclpnpyah6yfjqlfjlasrrhzj48lqmm5a91nyps5yqyn";
  };

  pythonPath = with pythonPackages; [ dns m2crypto ipaddr python-gnupg
                                      pyunbound ];

  buildInputs = [ pythonPackages.wrapPython ];
  propagatedBuildInputs = [ unbound libreswan ] ++ pythonPath;
  propagatedUserEnvPkgs = [ unbound libreswan ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "$(DESTDIR)/usr" "$out"
    substituteInPlace ipseckey \
      --replace "/usr/sbin/ipsec" "${libreswan}/sbin/ipsec"
    substituteInPlace tlsa \
      --replace "/var/lib/unbound/root" "${pythonPackages.pyunbound}/etc/pyunbound/root"
    patchShebangs *
    '';

  installPhase = ''
    mkdir -p $out/bin $out/man $out/${python.sitePackages}/
    make install
    wrapPythonPrograms
   '';

   meta = {
    description = "Various tools to generate special DNS records";
    homepage    = "https://github.com/letoams/hash-slinger";
    license     = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.leenaars ];
  };
}
