{ stdenv, fetchurl, makeWrapper, rrdtool, perl, perlPackages
, plugins ? []
}:

let pluginDeps = with perlPackages;   [
  Log4Perl IOSocketInet6 Socket6 URI DBFile DateManip
  HTMLTemplate FileCopyRecursive FCGI NetCIDR NetSNMP NetServer
  ListMoreUtils TimeHiRes DBDPg LWPUserAgent rrdtool
  LogDispatch DBDSQLite
  # for munin-httpd
  HTTPServerSimpleCGI IOString HTMLTemplatePro XMLDumper XMLParser JSON
] ++ (stdenv.lib.concatMap (x: x.propagatedBuildInputs) plugins);

in stdenv.mkDerivation rec {
  version = "2.999.3";
  name = "munin-${version}";

  src = fetchurl {
    url = "https://github.com/munin-monitoring/munin/archive/${version}.tar.gz";
    sha256 = "18rnlcsim50mnfm25pdn8wz6mqkh90p7frfsgmbspph6najq3qqj";
  };

  buildInputs = [ perl makeWrapper rrdtool ]
   ++ (with perlPackages; [
    ModuleBuild
    LogDispatch
    ParamsValidate
    LWPUserAgent
    HTMLTemplate
    
    NetCIDR
    NetSSLeay
    NetServer
    Log4Perl
    IOSocketInet6
    Socket6
    URI
    DBFile
    DateManip
    FileCopyRecursive
    FCGI
    NetSNMP
    NetServer
    ListMoreUtils
    TimeHiRes
    DBDPg
   ]);

  propagatedBuildInputs = pluginDeps;
   
  patchPhase = ''
    # their Makefile isn't very flexible
    rm -f Makefile
    
    # didn't find better way to set MUNIN_BINDIR
    sed -i 's/$Config{installsitebin}/$build->install_path('"'"'script'"'"')/g' Build.PL
    
    # munin hardcodes PATH, we need it to obey $PATH
    sed -i '/ENV{PATH}/d' lib/Munin/Node/Service.pm
    
    # couldn't figure out, why rrdtool isn't found in PATH while being run as systemd service
    sed -i 's|"rrdtool"|"${rrdtool}/bin/rrdtool"|g' lib/Munin/Master/Graph.pm
    
    # this fixes rrdtool graph generation
    sed -i 's|\\\\l||g' lib/Munin/Master/Graph.pm
  '';
  
  buildPhase = ''
    # fragile, but otherwise manual rearrangement of directories is required
    perl Build.PL --destdir $out \
       --install_path script=$out/bin \
       --install_path lib=lib/perl5/site_perl \
       --install_path bindoc=share/man/man1 \
       --install_path libdoc=share/man/man3 \
       --install_path share=$out/share \
       --install_path etc=$out/share \
       --install_path web=$out/share \
       --install_path plugins=$out/share/plugins \
       --install_path arch=/dev/null \
       --install_path var=/var \
       --install_path MUNIN_BINDIR=$out/bin
  '';

  installPhase = ''
    ./Build install --destdir $out \
       --install_path script=bin \
       --install_path lib=lib/perl5/site_perl \
       --install_path bindoc=share/man/man1 \
       --install_path libdoc=share/man/man3 \
       --install_path share=share \
       --install_path etc=share \
       --install_path web=share \
       --install_path plugins=share/plugins \
       --install_path arch=/dev/null \
       --install_path var=/var \
       --install_path MUNIN_BINDIR=$out/bin
  '';
  
  postFixup = ''
    echo "Removing references to /usr/{bin,sbin}/ from munin plugins..."
    find "$out/share/plugins" -type f -print0 | xargs -0 -L1 sed -i -e "s|/usr/bin/||g" -e "s|/usr/sbin/||g"

    for file in $out/bin/* ; do
        wrapProgram "$file" \
          --set PERL5LIB "$out/lib/perl5/site_perl:${perlPackages.makeFullPerlPath pluginDeps}" \
          --set PERL6LIB "$out/lib/perl5/site_perl:${perlPackages.makeFullPerlPath pluginDeps}"

    done
  '';

  meta = with stdenv.lib; {
    description = "Networked resource monitoring tool";
    longDescription = ''
      Munin is a monitoring tool that surveys all your computers and remembers
      what it saw. It presents all the information in graphs through a web
      interface. Munin can help analyze resource trends and 'what just happened
      to kill our performance?' problems.
    '';
    homepage = https://munin-monitoring.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ danbst ];
    platforms = platforms.linux;
  };
}
