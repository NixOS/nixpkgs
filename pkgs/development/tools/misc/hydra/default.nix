{stdenv, fetchurl, nix, perlPackages, perl, makeWrapper, libtool,
unzip, nukeReferences, pkgconfig, boehmgc, libxslt, sqlite,
subversion, openssh, coreutils, findutils, gzip, bzip2, lzma,
gnutar, git, mercurial, gnused, graphviz, rpm, dpkg, cdrkit
}:

let
  perldeps = with perlPackages; [ 
  CatalystDevel
  CatalystPluginSessionStoreFastMmap
  CatalystPluginStackTrace
  CatalystPluginAuthorizationRoles
  CatalystAuthenticationStoreDBIxClass
  CatalystViewTT
  CatalystEngineHTTPPrefork
  CatalystViewDownload
  XMLSimple
  IPCRun
  IOCompressBzip2
  Readonly
  DBDPg
  EmailSender
  TextTable
  NetTwitterLite
  PadWalker
  DataDump
  JSONXS
  DateTime
  DigestSHA1
  CryptRandPasswd
  nixPerl
  ];
in

stdenv.mkDerivation rec {
  name = "hydra-${version}";
  version = "0.1pre27415";
  src = fetchurl {
    url = http://hydra.nixos.org/build/1114800/download/2/hydra-0.1pre27415.tar.gz;
    sha256 = "17ris0wn486qb0ibgl8h6gb94gaiy0vbjpbv48sczp93cns5v0vh";
  };

  configureFlags = "--with-nix=${nix}";

  buildInputs = [ perl makeWrapper libtool nix unzip nukeReferences pkgconfig boehmgc ] ++ perldeps ;

  hydraPath = stdenv.lib.concatStringsSep ":" (map (p: "${p}/bin") ( [
    libxslt sqlite subversion openssh nix coreutils findutils
    gzip bzip2 lzma gnutar unzip git mercurial gnused graphviz
    rpm dpkg cdrkit]));

  postInstall = ''
    for i in "$out/bin/"*; do
        wrapProgram $i \
            --prefix PERL5LIB ':' $out/libexec/hydra/lib:$PERL5LIB \
            --prefix PATH ':' $out/bin:$hydraPath \
            --set HYDRA_RELEASE ${version} \
            --set HYDRA_HOME $out/libexec/hydra \
            --set NIX_RELEASE ${nix.name}
    done
  '';

  meta = {
    description = "Hydra, the Nix-based continuous integration system";
    homepage = http://nixos.org/hydra/;
    license = "GPLv3+";
    platforms = stdenv.lib.platforms.linux;
  };
}
