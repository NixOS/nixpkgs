{ stdenv, fetchurl, nix, perlPackages, perl, makeWrapper, libtool
, unzip, nukeReferences, pkgconfig, boehmgc, libxslt, sqlite
, subversion, openssh, coreutils, findutils, gzip, bzip2, lzma
, gnutar, git, mercurial, gnused, graphviz, rpm, dpkg, cdrkit
}:

let

  perldeps = with perlPackages; 
    [ CatalystDevel
      CatalystPluginSessionStoreFastMmap
      CatalystPluginStackTrace
      CatalystPluginAuthorizationRoles
      CatalystAuthenticationStoreDBIxClass
      CatalystViewTT
      CatalystEngineHTTPPrefork
      CatalystViewDownload
      XMLSimple
      IPCRun
      IOCompress
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

  version = "0.1pre27592"; 

in

stdenv.mkDerivation {
  name = "hydra-${version}";

  src = fetchurl {
    url = http://hydra.nixos.org/build/1142240/download/2/hydra-0.1pre27592.tar.gz;
    sha256 = "0197bcfkabqqv7611fh9kjabfm0nfci8kanfaa59hqwf3h6fmpwz";
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
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
