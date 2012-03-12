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
    url = "http://hydra.nixos.org/build/1264023/download/2/hydra-${version}.tar.gz";
    sha256 = "62cecc2da9cb0353ab4eb1f66b6783c0195421c35ba6b6eace9d3b56a9275631";
  };

  configureFlags = "--with-nix=${nix}";

  buildInputs = [ perl makeWrapper libtool nix unzip nukeReferences pkgconfig boehmgc ] ++ perldeps ;

  hydraPath = stdenv.lib.concatStringsSep ":" (map (p: "${p}/bin") ( 
    [ libxslt sqlite subversion openssh nix coreutils findutils
      gzip bzip2 lzma gnutar unzip git mercurial gnused graphviz
      rpm dpkg cdrkit
    ]));

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
